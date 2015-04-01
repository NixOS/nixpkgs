export NIX_CC=@out@

addCVars () {
    if [ -d $1/include ]; then
        export NIX_CFLAGS_COMPILE+=" -isystem $1/include"
    fi

    if [ -d $1/lib64 -a ! -L $1/lib64 ]; then
        export NIX_LDFLAGS+=" -L$1/lib64"
    fi

    if [ -d $1/lib ]; then
        export NIX_LDFLAGS+=" -L$1/lib"
    fi

    if test -d $1/Library/Frameworks; then
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -F$1/Library/Frameworks"
    fi
}

envHooks+=(addCVars)

# Note: these come *after* $out in the PATH (see setup.sh).

if [ -n "@cc@" ]; then
    addToSearchPath PATH @cc@/bin
fi

if [ -n "@binutils@" ]; then
    addToSearchPath PATH @binutils@/bin
fi

if [ -n "@libc@" ]; then
    addToSearchPath PATH @libc@/bin
fi

if [ -n "@coreutils@" ]; then
    addToSearchPath PATH @coreutils@/bin
fi

if [ -z "$crossConfig" ]; then
    export CC=@real_cc@
    export CXX=@real_cxx@
else
    export BUILD_CC=@real_cc@
    export BUILD_CXX=@real_cxx@
fi
