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

@promptInit@
@initBashCompletion@

# Some aliases.
alias ls="ls --color=tty"
alias ll="ls -l"
alias l="ls -alh"
alias which="type -P"

# Convenience for people used to Upstart.
alias start="systemctl start"
alias stop="systemctl stop"
alias restart="systemctl restart"
alias status="systemctl status"
