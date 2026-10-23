# See cc-wrapper for comments.
var_templates_list=(
    NIX_IGNORE_LD_THROUGH_GCC
    NIX_LDFLAGS
    NIX_LDFLAGS_BEFORE
    NIX_DYNAMIC_LINKER
    NIX_LDFLAGS_AFTER
    NIX_LDFLAGS_HARDEN
    NIX_HARDENING_ENABLE
)
var_templates_bool=(
    NIX_SET_BUILD_ID
    NIX_DONT_SET_RPATH
)

accumulateRoles

for var in "${var_templates_list[@]}"; do
    mangleVarList "$var" ${role_suffixes[@]+"${role_suffixes[@]}"}
done
for var in "${var_templates_bool[@]}"; do
    mangleVarBool "$var" ${role_suffixes[@]+"${role_suffixes[@]}"}
done

if [ -e @out@/nix-support/libc-ldflags ]; then
    NIX_LDFLAGS_@suffixSalt@+=" $(< @out@/nix-support/libc-ldflags)"
fi

if [ -z "$NIX_DYNAMIC_LINKER_@suffixSalt@" ] && [ -e @out@/nix-support/ld-set-dynamic-linker ]; then
    NIX_DYNAMIC_LINKER_@suffixSalt@="$(< @out@/nix-support/dynamic-linker)"
fi

if [ -e @out@/nix-support/libc-ldflags-before ]; then
    NIX_LDFLAGS_BEFORE_@suffixSalt@="$(< @out@/nix-support/libc-ldflags-before) $NIX_LDFLAGS_BEFORE_@suffixSalt@"
fi

export NIX_BINTOOLS_WRAPPER_FLAGS_SET_@suffixSalt@=1
