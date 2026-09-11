#!/bin/sh
set -eu
export GPG_TTY=$(tty)
exec @OUT@/bin/gopass-jsonapi listen
