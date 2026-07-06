#! @shell@
# shellcheck shell=bash

args=()
for p in "$@"; do
    case "$p" in
        -t)
            # Skip, LLVM ranlib doesn't support
            ;;
        *)
            args+=("$p")
            ;;
    esac
done

@prog@ "${args[@]}"
