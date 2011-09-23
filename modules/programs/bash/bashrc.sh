# /etc/bashrc: DO NOT EDIT -- this file has been generated automatically.

if [ \( -n "${SYSTEM_ETC_BASHRC_HAS_BEEN_SOURCED:-}" \) -o \( -n "${NOSYSBASHRC:-}" \) ]; then
    return
else
    SYSTEM_ETC_BASHRC_HAS_BEEN_SOURCED="1"
fi

. /etc/profile

# If we are an interactive shell ...
if [ -n "$PS1" ]; then
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
    alias which="type -P"
fi
