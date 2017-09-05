# See cc-wrapper for comments.
var_templates_list=(
    NIX+IGNORE_LD_THROUGH_GCC
    NIX+LDFLAGS
    NIX+LDFLAGS_BEFORE
    NIX+LDFLAGS_AFTER
    NIX+LDFLAGS_HARDEN
)
var_templates_bool=(
    NIX+SET_BUILD_ID
    NIX+DONT_SET_RPATH
)

declare -a role_infixes=()
if [ "${NIX_BINUTILS_WRAPPER_@infixSalt@_TARGET_BUILD:-}" ]; then
    role_infixes+=(_BUILD_)
fi
if [ "${NIX_BINUTILS_WRAPPER_@infixSalt@_TARGET_HOST:-}" ]; then
    role_infixes+=(_)
fi
if [ "${NIX_BINUTILS_WRAPPER_@infixSalt@_TARGET_TARGET:-}" ]; then
    role_infixes+=(_TARGET_)
fi

for var in "${var_templates_list[@]}"; do
    mangleVarList "$var" "${role_infixes[@]}"
done
for var in "${var_templates_bool[@]}"; do
    mangleVarBool "$var" "${role_infixes[@]}"
done

if [ -e @out@/nix-support/libc-ldflags ]; then
    NIX_@infixSalt@_LDFLAGS+=" $(< @out@/nix-support/libc-ldflags)"
fi

if [ -e @out@/nix-support/libc-ldflags-before ]; then
    NIX_@infixSalt@_LDFLAGS_BEFORE="$(< @out@/nix-support/libc-ldflags-before) $NIX_@infixSalt@_LDFLAGS_BEFORE"
fi

export NIX_BINUTILS_WRAPPER_@infixSalt@_FLAGS_SET=1
