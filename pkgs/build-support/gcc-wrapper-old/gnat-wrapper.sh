#! @shell@ -e

if test -n "$NIX_GNAT_WRAPPER_START_HOOK"; then
    source "$NIX_GNAT_WRAPPER_START_HOOK"
fi

if test -z "$NIX_GNAT_WRAPPER_FLAGS_SET"; then
    source @out@/nix-support/add-flags.sh
fi

source @out@/nix-support/utils.sh


# Figure out if linker flags should be passed.  GCC prints annoying
# warnings when they are not needed.
dontLink=0
getVersion=0
nonFlagArgs=0

for i in "$@"; do
    if test "$i" = "-c"; then
        dontLink=1
    elif test "$i" = "-M"; then
        dontLink=1
    elif test "${i:0:1}" != "-"; then
        nonFlagArgs=1
    elif test "$i" = "-m32"; then
        if test -e @out@/nix-support/dynamic-linker-m32; then
            NIX_LDFLAGS="$NIX_LDFLAGS -dynamic-linker $(cat @out@/nix-support/dynamic-linker-m32)"
        fi
    fi
done

# If we pass a flag like -Wl, then gcc will call the linker unless it
# can figure out that it has to do something else (e.g., because of a
# "-c" flag).  So if no non-flag arguments are given, don't pass any
# linker flags.  This catches cases like "gcc" (should just print
# "gcc: no input files") and "gcc -v" (should print the version).
if test "$nonFlagArgs" = "0"; then
    dontLink=1
fi


# Optionally filter out paths not refering to the store.
params=("$@")
if test "$NIX_ENFORCE_PURITY" = "1" -a -n "$NIX_STORE"; then
    rest=()
    n=0
    while test $n -lt ${#params[*]}; do
        p=${params[n]}
        p2=${params[$((n+1))]}
        if test "${p:0:3}" = "-L/" && badPath "${p:2}"; then
            skip $p
        elif test "${p:0:3}" = "-I/" && badPath "${p:2}"; then
            skip $p
        elif test "${p:0:4}" = "-aI/" && badPath "${p:3}"; then
            skip $p
        elif test "${p:0:4}" = "-aO/" && badPath "${p:3}"; then
            skip $p
        else
            rest=("${rest[@]}" "$p")
        fi
        n=$((n + 1))
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
if test "$NIX_DEBUG" = "1"; then
  echo "original flags to @gnatProg@:" >&2
  for i in "${params[@]}"; do
      echo "  $i" >&2
  done
  echo "extraBefore flags to @gnatProg@:" >&2
  for i in ${extraBefore[@]}; do
      echo "  $i" >&2
  done
  echo "extraAfter flags to @gnatProg@:" >&2
  for i in ${extraAfter[@]}; do
      echo "  $i" >&2
  done
fi

if test -n "$NIX_GNAT_WRAPPER_EXEC_HOOK"; then
    source "$NIX_GNAT_WRAPPER_EXEC_HOOK"
fi


# Call the real `gcc'.  Filter out warnings from stderr about unused
# `-B' flags, since they confuse some programs.  Deep bash magic to
# apply grep to stderr (by swapping stdin/stderr twice).
if test -z "$NIX_GNAT_NEEDS_GREP"; then
    @gnatProg@ ${extraBefore[@]} "${params[@]}" ${extraAfter[@]}
else
    (@gnatProg@ ${extraBefore[@]} "${params[@]}" ${extraAfter[@]} 3>&2 2>&1 1>&3- \
        | (grep -v 'file path prefix' || true); exit ${PIPESTATUS[0]}) 3>&2 2>&1 1>&3-
    exit $?
fi
