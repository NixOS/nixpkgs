# /etc/bashrc: DO NOT EDIT -- this file has been generated automatically.

# This file is read for interactive non-login shells.

# Only execute this file once per shell.
if [ -n "$__ETC_BASHRC_SOURCED" -o -n "$NOSYSBASHRC" ]; then return; fi
__ETC_BASHRC_SOURCED=1

# If the profile was not loaded in a parent process, source it.  But
# otherwise don't do it because we don't want to clobber overriden
# values of $PATH, etc.
if [ -z "$__ETC_PROFILE_DONE" ]; then
    . /etc/profile
fi

# We are not always an interactive shell.
if [ -z "$PS1" ]; then return; fi

# Check the window size after every command.
shopt -s checkwinsize

# Provide a nice prompt.
PROMPT_COLOR="1;31m"
let $UID && PROMPT_COLOR="1;32m"
PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
if test "$TERM" = "xterm"; then
    PS1="\[\033]2;\h:\u:\w\007\]$PS1"
fi

# Check whether we're running a version of Bash that has support for
# programmable completion. If we do, and if the current user has
# installed the package 'bash-completion' in her $HOME/.nix-profile,
# then completion is enabled automatically.
if [ -f "$HOME/.nix-profile/etc/bash_completion" ]; then
    if [ -d "$HOME/.nix-profile/etc/bash_completion.d" ]; then
        if shopt -q progcomp &>/dev/null; then
            BASH_COMPLETION_DIR="$HOME/.nix-profile/etc/bash_completion.d"
            BASH_COMPLETION="$HOME/.nix-profile/etc/bash_completion"
            . "$BASH_COMPLETION"
        fi
    fi
fi

# Some aliases.
alias ls="ls --color=tty"
alias ll="ls -l"
alias l="ls -alh"
alias which="type -P"
