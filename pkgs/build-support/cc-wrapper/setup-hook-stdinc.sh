# This is an alternate setup hook for gcc-wrapper that uses the -I flag to
# add include search paths instead of -isystem. We need this for some packages
# because -isystem can change the search order specified by prior -I flags.
# Changing the search order can point gcc to the wrong package's headers.
# The -I flag will never change the order of prior flags.

export NIX_CC=@out@

addCVars () {
    if [ -d $1/include ]; then
        export NIX_CFLAGS_COMPILE+=" -I $1/include"
    fi

    if [ -d $1/lib64 -a ! -L $1/lib64 ]; then
        export NIX_LDFLAGS+=" -L$1/lib64"
    fi

    if [ -d $1/lib ]; then
        export NIX_LDFLAGS+=" -L$1/lib"
    fi
}

envHooks+=(addCVars)

# Note: these come *after* $out in the PATH (see setup.sh).

if [ -n "@gcc@" ]; then
    addToSearchPath PATH @gcc@/bin
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

export CC=gcc
export CXX=g++
