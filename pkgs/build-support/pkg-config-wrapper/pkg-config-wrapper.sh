#! @shell@
set -eu -o pipefail +o posix
shopt -s nullglob

if (( "${NIX_DEBUG:-0}" >= 7 )); then
    set -x
fi

source @out@/nix-support/utils.bash

if [ -z "${NIX_PKG_CONFIG_WRAPPER_FLAGS_SET_@suffixSalt@:-}" ]; then
    source @out@/nix-support/add-flags.sh
fi

set -- @addFlags@ "$@"

if (( ${#role_suffixes[@]} > 0 )); then
    # replace env var with nix-modified one
    PKG_CONFIG_PATH=$PKG_CONFIG_PATH_@suffixSalt@ exec @prog@ "$@"
else
    # pkg-config isn't a real dependency so ignore setup hook entirely
    exec @prog@ "$@"
fi
