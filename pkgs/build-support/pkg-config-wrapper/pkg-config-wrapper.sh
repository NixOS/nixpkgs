#! @shell@
set -eu -o pipefail +o posix
shopt -s nullglob

if (( "${NIX_DEBUG:-0}" >= 7 )); then
    set -x
fi

source @out@/nix-support/utils.bash
wrapperClear
source @out@/nix-support/add-flags.sh

set -- @addFlags@ "$@"

if (( ${#role_suffixes[@]} > 0 )); then
    exportProjectedVar PKG_CONFIG_PATH "$wrapper_PKG_CONFIG_PATH"
fi

# Without an active role, preserve the incoming tool environment.
exec @prog@ "$@"
