#! /bin/sh

if test -n "$NIX_GCC_WRAPPER_START_HOOK"; then
    . "$NIX_GCC_WRAPPER_START_HOOK"
fi

if test -z "$NIX_GLIBC_FLAGS_SET"; then
    NIX_CFLAGS_COMPILE="@cflagsCompile@ $NIX_CFLAGS_COMPILE"
    NIX_CFLAGS_LINK="@cflagsLink@ $NIX_CFLAGS_LINK"
    NIX_LDFLAGS="@ldflags@ $NIX_LDFLAGS"
fi


# Figure out if linker flags should be passed.  GCC prints annoying
# warnings when they are not needed.
dontLink=0
if test "$*" = "-v"; then
    dontLink=1
else    
    for i in "$@"; do
        if test "$i" = "-c"; then
            dontLink=1
        elif test "$i" = "-S"; then
            dontLink=1
        elif test "$i" = "-E"; then
            dontLink=1
        elif test "$i" = "-E"; then
            dontLink=1
        elif test "$i" = "-M"; then
            dontLink=1
        elif test "$i" = "-MM"; then
            dontLink=1
        fi
    done
fi


# Optionally filter out paths not refering to the store.
skip () {
    if test "$NIX_DEBUG" = "1"; then
        echo "skipping impure path $1" >&2
    fi
}

params=("$@")
if test "$NIX_ENFORCE_PURITY" = "1" -a -n "$NIX_STORE"; then
    rest=()
    n=0
    while test $n -lt ${#params[*]}; do
        p=${params[n]}
        p2=${params[$((n+1))]}
        if test "${p:0:3}" = "-L/" -a "${p:2:${#NIX_STORE}}" != "$NIX_STORE"; then
            skip $p
        elif test "$p" = "-L" -a "${p2:0:${#NIX_STORE}}" != "$NIX_STORE"; then
            n=$((n + 1)); skip $p2
        elif test "${p:0:3}" = "-I/" -a "${p:2:${#NIX_STORE}}" != "$NIX_STORE"; then
            skip $p
        elif test "$p" = "-I" -a "${p2:0:${#NIX_STORE}}" != "$NIX_STORE"; then
            n=$((n + 1)); skip $p2
        elif test "$p" = "-isystem" -a "${p2:0:${#NIX_STORE}}" != "$NIX_STORE"; then
            n=$((n + 1)); skip $p2
        else
            rest=("${rest[@]}" "$p")
        fi
        n=$((n + 1))
    done
    params=("${rest[@]}")
fi


# Add the flags for the C compiler proper.
extra=($NIX_CFLAGS_COMPILE)

if test "$dontLink" != "1"; then

    # Add the flags that should only be passed to the compiler when
    # linking.
    extra=(${extra[@]} $NIX_CFLAGS_LINK)

    # Add the flags that should be passed to the linker (and prevent
    # `ld-wrapper' from adding NIX_LDFLAGS again).
    for i in $NIX_LDFLAGS; do
        extra=(${extra[@]} "-Wl,$i")
    done
    export NIX_LDFLAGS_SET=1

    if test "$NIX_STRIP_DEBUG" = "1"; then
        # Add executable-stripping flags.
        extra=(${extra[@]} $NIX_CFLAGS_STRIP)
    fi
fi

# Optionally print debug info.
if test "$NIX_DEBUG" = "1"; then
  echo "original flags to @gcc@:" >&2
  for i in "${params[@]}"; do
      echo "  $i" >&2
  done
  echo "extra flags to @gcc@:" >&2
  for i in ${extra[@]}; do
      echo "  $i" >&2
  done
fi

if test -n "$NIX_GCC_WRAPPER_EXEC_HOOK"; then
    . "$NIX_GCC_WRAPPER_EXEC_HOOK"
fi

exec @gcc@ "${params[@]}" ${extra[@]}
