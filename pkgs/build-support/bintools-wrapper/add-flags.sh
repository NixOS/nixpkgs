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
    wrapper_NIX_LDFLAGS+=" $(< @out@/nix-support/libc-ldflags)"
fi

if [ -z "$wrapper_NIX_DYNAMIC_LINKER" ] && [ -e @out@/nix-support/ld-set-dynamic-linker ]; then
    wrapper_NIX_DYNAMIC_LINKER="$(< @out@/nix-support/dynamic-linker)"
fi

if [ -e @out@/nix-support/libc-ldflags-before ]; then
    wrapper_NIX_LDFLAGS_BEFORE="$(< @out@/nix-support/libc-ldflags-before) $wrapper_NIX_LDFLAGS_BEFORE"
fi
