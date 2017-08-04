#! @shell@
set -e -o pipefail
shopt -s nullglob

# Add the flags for the GNAT compiler proper.
extraAfter=("--GCC=@out@/bin/gcc")
extraBefore=()

## Add the flags that should be passed to the linker (and prevent
## `ld-wrapper' from adding NIX_LDFLAGS again).
#for i in $NIX_LDFLAGS_BEFORE; do
#    extraBefore+=("-largs" "$i")
#done
#for i in $NIX_LDFLAGS; do
#    if [ "${i:0:3}" = -L/ ]; then
#        extraAfter+=("$i")
#    else
#        extraAfter+=("-largs" "$i")
#    fi
#done
#export NIX_LDFLAGS_SET=1

# Optionally print debug info.
if [ -n "$NIX_DEBUG" ]; then
    echo "extra flags before to @prog@:" >&2
    printf "  %q\n" "${extraBefore[@]}"  >&2
    echo "original flags to @prog@:" >&2
    printf "  %q\n" "$@" >&2
    echo "extra flags after to @prog@:" >&2
    printf "  %q\n" "${extraAfter[@]}" >&2
fi

if [ -n "$NIX_GNAT_WRAPPER_EXEC_HOOK" ]; then
    source "$NIX_GNAT_WRAPPER_EXEC_HOOK"
fi

exec @prog@ "${extraBefore[@]}" "$@" "${extraAfter[@]}"
