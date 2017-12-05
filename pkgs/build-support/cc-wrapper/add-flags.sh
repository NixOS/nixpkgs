# N.B. It may be a surprise that the derivation-specific variables are exported,
# since this is just sourced by the wrapped binaries---the end consumers. This
# is because one wrapper binary may invoke another (e.g. cc invoking ld). In
# that case, it is cheaper/better to not repeat this step and let the forked
# wrapped binary just inherit the work of the forker's wrapper script.

var_templates=(
    NIX_CC_WRAPPER+START_HOOK
    NIX_CC_WRAPPER+EXEC_HOOK
    NIX_LD_WRAPPER+START_HOOK
    NIX_LD_WRAPPER+EXEC_HOOK

    NIX+CFLAGS_COMPILE
    NIX+CFLAGS_LINK
    NIX+CXXSTDLIB_COMPILE
    NIX+CXXSTDLIB_LINK
    NIX+GNATFLAGS_COMPILE
    NIX+IGNORE_LD_THROUGH_GCC
    NIX+LDFLAGS
    NIX+LDFLAGS_BEFORE
    NIX+LDFLAGS_AFTER
    NIX+LDFLAGS_HARDEN

    NIX+SET_BUILD_ID
    NIX+DONT_SET_RPATH
    NIX+ENFORCE_NO_NATIVE
)

# Accumulate infixes for taking in the right input parameters. See setup-hook
# for details.
declare -a role_infixes=()
if [ "${NIX_CC_WRAPPER_@infixSalt@_TARGET_BUILD:-}" ]; then
    role_infixes+=(_BUILD_)
fi
if [ "${NIX_CC_WRAPPER_@infixSalt@_TARGET_HOST:-}" ]; then
    role_infixes+=(_)
fi
if [ "${NIX_CC_WRAPPER_@infixSalt@_TARGET_TARGET:-}" ]; then
    role_infixes+=(_TARGET_)
fi

# We need to mangle names for hygiene, but also take parameters/overrides
# from the environment.
for var in "${var_templates[@]}"; do
    outputVar="${var/+/_@infixSalt@_}"
    export ${outputVar}+=''
    # For each role we serve, we accumulate the input parameters into our own
    # cc-wrapper-derivation-specific environment variables.
    for infix in "${role_infixes[@]}"; do
        inputVar="${var/+/${infix}}"
        if [ -v "$inputVar" ]; then
            export ${outputVar}+="${!outputVar:+ }${!inputVar}"
        fi
    done
done

# `-B@out@/bin' forces cc to use ld-wrapper.sh when calling ld.
NIX_@infixSalt@_CFLAGS_COMPILE="-B@out@/bin/ $NIX_@infixSalt@_CFLAGS_COMPILE"

# Export and assign separately in order that a failing $(..) will fail
# the script.

if [ -e @out@/nix-support/libc-cflags ]; then
    NIX_@infixSalt@_CFLAGS_COMPILE="$(< @out@/nix-support/libc-cflags) $NIX_@infixSalt@_CFLAGS_COMPILE"
fi

if [ -e @out@/nix-support/cc-cflags ]; then
    NIX_@infixSalt@_CFLAGS_COMPILE="$(< @out@/nix-support/cc-cflags) $NIX_@infixSalt@_CFLAGS_COMPILE"
fi

if [ -e @out@/nix-support/gnat-cflags ]; then
    NIX_@infixSalt@_GNATFLAGS_COMPILE="$(< @out@/nix-support/gnat-cflags) $NIX_@infixSalt@_GNATFLAGS_COMPILE"
fi

if [ -e @out@/nix-support/libc-ldflags ]; then
    NIX_@infixSalt@_LDFLAGS+=" $(< @out@/nix-support/libc-ldflags)"
fi

if [ -e @out@/nix-support/cc-ldflags ]; then
    NIX_@infixSalt@_LDFLAGS+=" $(< @out@/nix-support/cc-ldflags)"
fi

if [ -e @out@/nix-support/libc-ldflags-before ]; then
    NIX_@infixSalt@_LDFLAGS_BEFORE="$(< @out@/nix-support/libc-ldflags-before) $NIX_@infixSalt@_LDFLAGS_BEFORE"
fi

# That way forked processes will not extend these environment variables again.
export NIX_CC_WRAPPER_@infixSalt@_FLAGS_SET=1
