addCVars () {
    if test -d $1/include; then
        export NIX_CFLAGS_COMPILE="-isystem $1/include $NIX_CFLAGS_COMPILE"
    fi

    if test -d $1/lib; then
        export NIX_LDFLAGS="-L$1/lib $NIX_LDFLAGS"
    fi

    if test -d $1/lib64; then
        export NIX_LDFLAGS="-L$1/lib64 $NIX_LDFLAGS"
    fi
}

envHooks+=(addCVars)

# Note: these come *after* $out in the PATH (see setup.sh).

if test -n "@gcc@"; then
    appendToSearchPath PATH @gcc@/bin
fi

if test -n "@binutils@"; then
    appendToSearchPath PATH @binutils@/bin
fi

if test -n "@libc@"; then
    appendToSearchPath PATH @libc_bin@/bin
fi

if test -n "@coreutils@"; then
    appendToSearchPath PATH @coreutils@/bin
fi
