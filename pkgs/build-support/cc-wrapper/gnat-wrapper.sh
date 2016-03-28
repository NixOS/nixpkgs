#! @shell@ -e
path_backup="$PATH"
if [ -n "@coreutils@" ]; then
  PATH="@coreutils@/bin"
fi

if [ -n "$NIX_GNAT_WRAPPER_START_HOOK" ]; then
    source "$NIX_GNAT_WRAPPER_START_HOOK"
fi

if [ -z "$NIX_GNAT_WRAPPER_FLAGS_SET" ]; then
    source @out@/nix-support/add-flags.sh
fi

source @out@/nix-support/utils.sh


# Figure out if linker flags should be passed.  GCC prints annoying
# warnings when they are not needed.
dontLink=0
getVersion=0
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
            NIX_LDFLAGS="$NIX_LDFLAGS -dynamic-linker $(cat @out@/nix-support/dynamic-linker-m32)"
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
if [ "$NIX_ENFORCE_PURITY" = 1 -a -n "$NIX_STORE" ]; then
    rest=()
    n=0
    while [ $n -lt ${#params[*]} ]; do
        p=${params[n]}
        p2=${params[$((n+1))]}
        if [ "${p:0:3}" = -L/ ] && badPath "${p:2}"; then
            skip $p
        elif [ "${p:0:3}" = -I/ ] && badPath "${p:2}"; then
            skip $p
        elif [ "${p:0:4}" = -aI/ ] && badPath "${p:3}"; then
            skip $p
        elif [ "${p:0:4}" = -aO/ ] && badPath "${p:3}"; then
            skip $p
        else
            rest+=("$p")
        fi
        n=$((n + 1))
    done
    params=("${rest[@]}")
fi


# Clear march/mtune=native -- they bring impurity.
if [ "$NIX_ENFORCE_NO_NATIVE" = 1 ]; then
    rest=()
    for i in "${params[@]}"; do
        if [[ "$i" = -m*=native ]]; then
            skip $i
        else
            rest+=("$i")
        fi
    done
    params=("${rest[@]}")
fi


# Add the flags for the GNAT compiler proper.
extraAfter=($NIX_GNATFLAGS_COMPILE)
extraBefore=()

if [ "`basename $0`x" = "gnatmakex" ]; then
  extraBefore=("--GNATBIND=@out@/bin/gnatbind --GNATLINK=@out@/bin/gnatlink ")
fi

# Add the flags that should be passed to the linker (and prevent
# `ld-wrapper' from adding NIX_LDFLAGS again).
#for i in $NIX_LDFLAGS_BEFORE; do
#    extraBefore=(${extraBefore[@]} "-largs $i")
#done

# Optionally print debug info.
if [ -n "$NIX_DEBUG" ]; then
  echo "original flags to @prog@:" >&2
  for i in "${params[@]}"; do
      echo "  $i" >&2
  done
  echo "extraBefore flags to @prog@:" >&2
  for i in ${extraBefore[@]}; do
      echo "  $i" >&2
  done
  echo "extraAfter flags to @prog@:" >&2
  for i in ${extraAfter[@]}; do
      echo "  $i" >&2
  done
fi

if [ -n "$NIX_GNAT_WRAPPER_EXEC_HOOK" ]; then
    source "$NIX_GNAT_WRAPPER_EXEC_HOOK"
fi

PATH="$path_backup"
exec @prog@ ${extraBefore[@]} "${params[@]}" ${extraAfter[@]}
