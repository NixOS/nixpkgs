#! @shell@
set -eu -o pipefail +o posix
shopt -s nullglob

if (( "${NIX_DEBUG:-0}" >= 7 )); then
    set -x
fi

export GCCGO="@out@/bin/gccgo"

exec @prog@ "$@"
