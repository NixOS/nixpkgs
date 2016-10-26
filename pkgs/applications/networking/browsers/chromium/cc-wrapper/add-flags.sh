# `-B@out@/bin' forces cc to use ld-wrapper.sh when calling ld.
export NIX_CFLAGS_COMPILE="-B@out@/bin/ $NIX_CFLAGS_COMPILE"

if [ -e @out@/nix-support/libc-cflags ]; then
    export NIX_CFLAGS_COMPILE="$(cat @out@/nix-support/libc-cflags) $NIX_CFLAGS_COMPILE"
fi

if [ -e @out@/nix-support/cc-cflags ]; then
    export NIX_CFLAGS_COMPILE="$(cat @out@/nix-support/cc-cflags) $NIX_CFLAGS_COMPILE"
fi

if [ -e @out@/nix-support/gnat-cflags ]; then
    export NIX_GNATFLAGS_COMPILE="$(cat @out@/nix-support/gnat-cflags) $NIX_GNATFLAGS_COMPILE"
fi

if [ -e @out@/nix-support/libc-ldflags ]; then
    export NIX_LDFLAGS+=" $(cat @out@/nix-support/libc-ldflags)"
fi

if [ -e @out@/nix-support/cc-ldflags ]; then
    export NIX_LDFLAGS+=" $(cat @out@/nix-support/cc-ldflags)"
fi

if [ -e @out@/nix-support/libc-ldflags-before ]; then
    export NIX_LDFLAGS_BEFORE="$(cat @out@/nix-support/libc-ldflags-before) $NIX_LDFLAGS_BEFORE"
fi

export NIX_CC_WRAPPER_FLAGS_SET=1
