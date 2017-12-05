#! @shell@
set -eu -o pipefail
shopt -s nullglob

# N.B. Gnat is not used during bootstrapping, so we don't need to
# worry about the old bash empty array `set -u` workarounds.

path_backup="$PATH"

# phase separation makes this look useless
# shellcheck disable=SC2157
if [ -n "@coreutils_bin@" ]; then
    PATH="@coreutils_bin@/bin"
fi

if [ -z "${NIX_@infixSalt@_GNAT_WRAPPER_FLAGS_SET:-}" ]; then
    source @out@/nix-support/add-flags.sh
fi

if [ -n "$NIX_@infixSalt@_GNAT_WRAPPER_START_HOOK" ]; then
    source "$NIX_@infixSalt@_GNAT_WRAPPER_START_HOOK"
fi

source @out@/nix-support/utils.sh


# Figure out if linker flags should be passed.  GCC prints annoying
# warnings when they are not needed.
dontLink=0
nonFlagArgs=0

for i in "$@"; do
    if [ "$i" = -c ]; then
        dontLink=1
    elif [ "$i" = -M ]; then
        dontLink=1
    elif [ "${i:0:1}" != - ]; then
        nonFlagArgs=1
    elif [ "$i" = -m32 ]; then
        if [ -e @out@/nix-support/dynamic-linker-m32 ]; then
            NIX_@infixSalt@_LDFLAGS+=" -dynamic-linker $(< @out@/nix-support/dynamic-linker-m32)"
        fi
    fi
done

# If we pass a flag like -Wl, then gcc will call the linker unless it
# can figure out that it has to do something else (e.g., because of a
# "-c" flag).  So if no non-flag arguments are given, don't pass any
# linker flags.  This catches cases like "gcc" (should just print
# "gcc: no input files") and "gcc -v" (should print the version).
if [ "$nonFlagArgs" = 0 ]; then
    dontLink=1
fi


# Optionally filter out paths not refering to the store.
params=("$@")
if [[ "${NIX_ENFORCE_PURITY:-}" = 1 && -n "$NIX_STORE" ]]; then
    rest=()
    for p in "${params[@]}"; do
        if [ "${p:0:3}" = -L/ ] && badPath "${p:2}"; then
            skip "${p:2}"
        elif [ "${p:0:3}" = -I/ ] && badPath "${p:2}"; then
            skip "${p:2}"
        elif [ "${p:0:4}" = -aI/ ] && badPath "${p:3}"; then
            skip "${p:2}"
        elif [ "${p:0:4}" = -aO/ ] && badPath "${p:3}"; then
            skip "${p:2}"
        else
            rest+=("$p")
        fi
    done
    params=("${rest[@]}")
fi


# Clear march/mtune=native -- they bring impurity.
if [ "$NIX_@infixSalt@_ENFORCE_NO_NATIVE" = 1 ]; then
    rest=()
    for p in "${params[@]}"; do
        if [[ "$p" = -m*=native ]]; then
            skip "$p"
        else
            rest+=("$p")
        fi
    done
    params=("${rest[@]}")
fi


# Add the flags for the GNAT compiler proper.
extraAfter=($NIX_@infixSalt@_GNATFLAGS_COMPILE)
extraBefore=()

if [ "$(basename "$0")x" = "gnatmakex" ]; then
  extraBefore=("--GNATBIND=@out@/bin/gnatbind" "--GNATLINK=@out@/bin/gnatlink ")
fi

#if [ "$dontLink" != 1 ]; then
#    # Add the flags that should be passed to the linker (and prevent
#    # `ld-wrapper' from adding NIX_@infixSalt@_LDFLAGS again).
#    for i in $NIX_@infixSalt@_LDFLAGS_BEFORE; do
#        extraBefore+=("-largs" "$i")
#    done
#    for i in $NIX_@infixSalt@_LDFLAGS; do
#        if [ "${i:0:3}" = -L/ ]; then
#            extraAfter+=("$i")
#        else
#            extraAfter+=("-largs" "$i")
#        fi
#    done
#    export NIX_@infixSalt@_LDFLAGS_SET=1
#fi

# Optionally print debug info.
if [ -n "${NIX_DEBUG:-}" ]; then
    echo "extra flags before to @prog@:" >&2
    printf "  %q\n" "${extraBefore[@]}"  >&2
    echo "original flags to @prog@:" >&2
    printf "  %q\n" "${params[@]}" >&2
    echo "extra flags after to @prog@:" >&2
    printf "  %q\n" "${extraAfter[@]}" >&2
fi

if [ -n "$NIX_@infixSalt@_GNAT_WRAPPER_EXEC_HOOK" ]; then
    source "$NIX_@infixSalt@_GNAT_WRAPPER_EXEC_HOOK"
fi

PATH="$path_backup"
exec @prog@ "${extraBefore[@]}" "${params[@]}" "${extraAfter[@]}"
