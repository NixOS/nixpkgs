addCVars () {
    if test -d $1/include; then
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$1/include"
    fi

    if test -d $1/lib; then
        export NIX_LDFLAGS="$NIX_LDFLAGS -L$1/lib -rpath $1/lib"
    fi
}

envHooks=(${envHooks[@]} addCVars)

export NIX_IS_NATIVE=@isNative@
if test -z "$NIX_IS_NATIVE"; then
    PATH=$PATH:@gcc@/bin:@glibc@/bin
fi

export NIX_ENFORCE_PURITY=@enforcePurity@
