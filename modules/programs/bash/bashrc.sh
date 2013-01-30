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

@interactiveShellInit@
