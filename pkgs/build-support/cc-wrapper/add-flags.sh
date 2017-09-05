# N.B. It may be a surprise that the derivation-specific variables are exported,
# since this is just sourced by the wrapped binaries---the end consumers. This
# is because one wrapper binary may invoke another (e.g. cc invoking ld). In
# that case, it is cheaper/better to not repeat this step and let the forked
# wrapped binary just inherit the work of the forker's wrapper script.

var_templates_list=(
    NIX+CFLAGS_COMPILE
    NIX+CFLAGS_LINK
    NIX+CXXSTDLIB_COMPILE
    NIX+CXXSTDLIB_LINK
    NIX+GNATFLAGS_COMPILE
)
var_templates_bool=(
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
for var in "${var_templates_list[@]}"; do
    mangleVarList "$var" "${role_infixes[@]}"
done
for var in "${var_templates_bool[@]}"; do
    mangleVarBool "$var" "${role_infixes[@]}"
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

if [ -e @out@/nix-support/cc-ldflags ]; then
    # We don't import this above, but just tack this on know. binutils-wrapper's
    # add-flags will not clobber it.
    #
    # TODO(@Ericson2314): Consider `NIX_@infixSalt@_CFLAGS_LINK` instead
    NIX_@infixSalt@_LDFLAGS+=" $(< @out@/nix-support/cc-ldflags)"
fi

# That way forked processes will not extend these environment variables again.
export NIX_CC_WRAPPER_@infixSalt@_FLAGS_SET=1
