addCVars () {
    if test -d $1/include; then
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$1/include"
    fi

    if test -d $1/lib64; then
        export NIX_LDFLAGS="$NIX_LDFLAGS -L$1/lib64"
    fi

    if test -d $1/lib; then
        export NIX_LDFLAGS="$NIX_LDFLAGS -L$1/lib"
    fi
}

envHooks=(${envHooks[@]} addCVars)

# Note: these come *after* $out in the PATH (see setup.sh).

if test -n "@clang@"; then
    addToSearchPath PATH @clang@/bin
fi

if test -n "@binutils@"; then
    addToSearchPath PATH @binutils@/bin
fi

if test -n "@libc@"; then
    addToSearchPath PATH @libc@/bin
fi

if test -n "@coreutils@"; then
    addToSearchPath PATH @coreutils@/bin
fi
