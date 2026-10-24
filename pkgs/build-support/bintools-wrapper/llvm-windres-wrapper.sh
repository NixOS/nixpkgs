#! @shell@
# shellcheck shell=bash

# llvm-rc, when invoked as windres, preprocesses .rc files with the first
# unprefixed `clang` it finds on PATH. In nixpkgs that is the unwrapped
# compiler, which lacks the include paths for the target's Windows headers.
# Unless the caller chose a preprocessor, use the wrapped compiler instead.
# It can only be located on PATH at run time, since the cc wrapper depends
# on this wrapper and not the other way around.

for p in "$@"; do
    case "$p" in
        --preprocessor|--preprocessor=*|--no-preprocess)
            exec @prog@ "$@"
            ;;
    esac
done

for cc in @targetPrefix@clang @targetPrefix@cc; do
    if ccPath=$(command -v "$cc" 2>/dev/null); then
        # --preprocessor replaces llvm-rc's whole default command, so its
        # default preprocessor flags have to be passed again explicitly.
        exec @prog@ \
            --preprocessor="$ccPath" \
            --preprocessor-arg=-E \
            --preprocessor-arg=-xc \
            --preprocessor-arg=-DRC_INVOKED \
            "$@"
    fi
done

exec @prog@ "$@"
