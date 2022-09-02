#! @shell@
# shellcheck shell=bash

@gnu_binutils_inject_plugin@
exec @prog@ "$@"
