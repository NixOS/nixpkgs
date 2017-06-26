# `-B@out@/bin' forces cc to use ld-wrapper.sh when calling ld.
export NIX_@infixSalt@_CFLAGS_COMPILE="-B@out@/bin/ $NIX_@infixSalt@_CFLAGS_COMPILE"

# Export and assign separately in order that a failing $(..) will fail
# the script.

if [ -e @out@/nix-support/libc-cflags ]; then
    export NIX_@infixSalt@_CFLAGS_COMPILE
    NIX_@infixSalt@_CFLAGS_COMPILE="$(< @out@/nix-support/libc-cflags) $NIX_@infixSalt@_CFLAGS_COMPILE"
fi

if [ -e @out@/nix-support/cc-cflags ]; then
    export NIX_@infixSalt@_CFLAGS_COMPILE
    NIX_@infixSalt@_CFLAGS_COMPILE="$(< @out@/nix-support/cc-cflags) $NIX_@infixSalt@_CFLAGS_COMPILE"
fi

if [ -e @out@/nix-support/gnat-cflags ]; then
    export NIX_@infixSalt@_GNATFLAGS_COMPILE
    NIX_@infixSalt@_GNATFLAGS_COMPILE="$(< @out@/nix-support/gnat-cflags) $NIX_@infixSalt@_GNATFLAGS_COMPILE"
fi

if [ -e @out@/nix-support/libc-ldflags ]; then
    export NIX_@infixSalt@_LDFLAGS
    NIX_@infixSalt@_LDFLAGS+=" $(< @out@/nix-support/libc-ldflags)"
fi

if [ -e @out@/nix-support/cc-ldflags ]; then
    export NIX_@infixSalt@_LDFLAGS
    NIX_@infixSalt@_LDFLAGS+=" $(< @out@/nix-support/cc-ldflags)"
fi

if [ -e @out@/nix-support/libc-ldflags-before ]; then
    export NIX_@infixSalt@_LDFLAGS_BEFORE
    NIX_@infixSalt@_LDFLAGS_BEFORE="$(< @out@/nix-support/libc-ldflags-before) $NIX_@infixSalt@_LDFLAGS_BEFORE"
fi

export NIX_CC_WRAPPER_@infixSalt@_FLAGS_SET=1
