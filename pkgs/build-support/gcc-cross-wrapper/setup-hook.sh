crossAddCVars () {
    if test -d $1/include; then
        export NIX_CROSS_CFLAGS_COMPILE="$NIX_CROSS_CFLAGS_COMPILE -I$1/include"
    fi

    if test -d $1/lib; then
        export NIX_CROSS_LDFLAGS="$NIX_CROSS_LDFLAGS -L$1/lib"
    fi
}

crossEnvHooks=(${crossEnvHooks[@]} crossAddCVars)

# Note: these come *after* $out in the PATH (see setup.sh).

if test -n "@gcc@"; then
    PATH=$PATH:@gcc@/bin
fi

if test -n "@binutils@"; then
    PATH=$PATH:@binutils@/bin
fi

if test -n "@libc@"; then
    PATH=$PATH:@libc@/bin
    crossAddCVars @libc@
fi

configureFlags="$configureFlags --build=$system --host=$crossConfig"
# Disabling the tests when cross compiling, as usually the tests are meant for
# native compilations.
doCheck=""

# Add the output as an rpath.
if test "$NIX_NO_SELF_RPATH" != "1"; then
    export NIX_CROSS_LDFLAGS="-rpath $out/lib -rpath-link $out/lib $NIX_CROSS_LDFLAGS"
    if test -n "$NIX_LIB64_IN_SELF_RPATH"; then
        export NIX_CROSS_LDFLAGS="-rpath $out/lib64 -rpath-link $out/lib $NIX_CROSS_LDFLAGS"
    fi
fi
