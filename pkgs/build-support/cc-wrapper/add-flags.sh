# N.B. It may be a surprise that the derivation-specific variables are exported,
# since this is just sourced by the wrapped binaries---the end consumers. This
# is because one wrapper binary may invoke another (e.g. cc invoking ld). In
# that case, it is cheaper/better to not repeat this step and let the forked
# wrapped binary just inherit the work of the forker's wrapper script.

var_templates_list=(
    NIX+CFLAGS_COMPILE
    NIX+CFLAGS_COMPILE_BEFORE
    NIX+CFLAGS_LINK
    NIX+CXXSTDLIB_COMPILE
    NIX+CXXSTDLIB_LINK
)
var_templates_bool=(
    NIX+ENFORCE_NO_NATIVE
)

accumulateRoles

# We need to mangle names for hygiene, but also take parameters/overrides
# from the environment.
for var in "${var_templates_list[@]}"; do
    mangleVarList "$var" ${role_infixes[@]+"${role_infixes[@]}"}
done
for var in "${var_templates_bool[@]}"; do
    mangleVarBool "$var" ${role_infixes[@]+"${role_infixes[@]}"}
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

if [ -e @out@/nix-support/cc-ldflags ]; then
    NIX_@infixSalt@_LDFLAGS+=" $(< @out@/nix-support/cc-ldflags)"
fi

if [ -e @out@/nix-support/cc-cflags-before ]; then
    NIX_@infixSalt@_CFLAGS_COMPILE_BEFORE="$(< @out@/nix-support/cc-cflags-before) $NIX_@infixSalt@_CFLAGS_COMPILE_BEFORE"
fi

# That way forked processes will not extend these environment variables again.
export NIX_CC_WRAPPER_@infixSalt@_FLAGS_SET=1
