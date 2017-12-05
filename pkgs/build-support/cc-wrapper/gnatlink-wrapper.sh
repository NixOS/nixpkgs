#! @shell@
set -eu -o pipefail +o posix
shopt -s nullglob

if (( "${NIX_DEBUG:-0}" >= 7 )); then
    set -x
fi

# N.B. Gnat is not used during bootstrapping, so we don't need to
# worry about the old bash empty array `set -u` workarounds.

# Add the flags for the GNAT compiler proper.
extraAfter=("--GCC=@out@/bin/gcc")
extraBefore=()

## Add the flags that should be passed to the linker (and prevent
## `ld-wrapper' from adding NIX_@infixSalt@_LDFLAGS again).
#for i in $NIX_@infixSalt@_LDFLAGS_BEFORE; do
#    extraBefore+=("-largs" "$i")
#done
#for i in $NIX_@infixSalt@_LDFLAGS; do
#    if [ "${i:0:3}" = -L/ ]; then
#        extraAfter+=("$i")
#    else
#        extraAfter+=("-largs" "$i")
#    fi
#done
#export NIX_@infixSalt@_LDFLAGS_SET=1

# Optionally print debug info.
if (( "${NIX_DEBUG:-0}" >= 1 )); then
    echo "extra flags before to @prog@:" >&2
    printf "  %q\n" "${extraBefore[@]}"  >&2
    echo "original flags to @prog@:" >&2
    printf "  %q\n" "$@" >&2
    echo "extra flags after to @prog@:" >&2
    printf "  %q\n" "${extraAfter[@]}" >&2
fi

exec @prog@ "${extraBefore[@]}" "$@" "${extraAfter[@]}"
