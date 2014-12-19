# get current branch in git repo
function parse_git_branch() {
   BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
   if [ ! "${BRANCH}" == "" ]
   then
      STAT=`parse_git_dirty`
      echo "[${BRANCH}${STAT}]"
   else
      echo ""
   fi
}

# get current status of git repo
function parse_git_dirty {
   status=`git status 2>&1 | tee`
   dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
   untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
   ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
   newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
   renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
   deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
   bits=''
   if [ "${renamed}" == "0" ]; then
      bits=">${bits}"
   fi
   if [ "${ahead}" == "0" ]; then
      bits="*${bits}"
   fi
   if [ "${newfile}" == "0" ]; then
      bits="+${bits}"
   fi
   if [ "${untracked}" == "0" ]; then
      bits="?${bits}"
   fi
   if [ "${deleted}" == "0" ]; then
      bits="x${bits}"
   fi
   if [ "${dirty}" == "0" ]; then
      bits="!${bits}"
   fi
   if [ ! "${bits}" == "" ]; then
      echo " ${bits}"
   else
      echo ""
   fi
}

export PS1="\w\e[0;36m\`parse_git_branch\`\e[0m \$ "
#export PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '
#this could be way cleaned up
PROMPT_COMMAND='echo -ne "\033]0; ${PWD##*/}\007" &&
if [ "$TERM_PROGRAM" == "Apple_Terminal" ] && [ -z "$INSIDE_EMACS" ]; then
    update_terminal_cwd() {
        local SEARCH=" "
        local REPLACE="%20"
        local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
        printf "\e]7;%s\a" "$PWD_URL"
    }
    PROMPT_COMMAND="update_terminal_cwd; $PROMPT_COMMAND"
fi'


function vimSearch {
   #arg one is filename, arg 2 is thing to search for
   vim +/$2 $1
}

alias vims=vimSearch

#interesting
#echo $(node --v8-options | grep harm | awk '{print $1}' | xargs)

function lightVim {
   cp ~/.vim/vimrc-base ~/.vim/vimrc-tmp
   cat ~/.vim/light-partial >> ~/.vim/vimrc-tmp
   sudo cp ~/.vim/vimrc-tmp /usr/share/vim/vimrc
}
function darkVim {
   cp ~/.vim/vimrc-base ~/.vim/vimrc-tmp
   cat ~/.vim/dark-partial >> ~/.vim/vimrc-tmp
   sudo cp ~/.vim/vimrc-tmp /usr/share/vim/vimrc
}
function darkVimSolarized {
   cp ~/.vim/vimrc-base ~/.vim/vimrc-tmp
   cat ~/.vim/dark-solarized-partial >> ~/.vim/vimrc-tmp
   sudo cp ~/.vim/vimrc-tmp /usr/share/vim/vimrc
}
