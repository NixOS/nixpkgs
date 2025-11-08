# See cc-wrapper for comments.
var_templates_list=(
    PKG_CONFIG_PATH
)

accumulateRoles

for var in "${var_templates_list[@]}"; do
    mangleVarListGeneric ":" "$var" ${role_suffixes[@]+"${role_suffixes[@]}"}
done

export NIX_PKG_CONFIG_WRAPPER_FLAGS_SET_@suffixSalt@=1
