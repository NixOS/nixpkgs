addCVars () {
    if test -d $1/include; then
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$1/include"
    fi

    if test -d $1/lib; then
        export NIX_LDFLAGS="$NIX_LDFLAGS -L$1/lib"
    fi
}

envHooks=(${envHooks[@]} addCVars)

# Note: these come *after* $out in the PATH (see setup.sh).

if test -n "@gcc@"; then
    PATH=$PATH:@gcc@/bin
fi

if test -n "@binutils@"; then
    PATH=$PATH:@binutils@/bin
fi

if test -n "@glibc@"; then
    PATH=$PATH:@glibc@/bin
fi

configureFlags="$configureFlags --build=$system --host=$crossConfig"
dontStrip=1
