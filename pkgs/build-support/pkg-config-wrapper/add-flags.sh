accumulateRoles

if (( ${#role_suffixes[@]} > 0 )); then
    restoreProjectedVar PKG_CONFIG_PATH
    mangleVarListGeneric ":" PKG_CONFIG_PATH "${role_suffixes[@]}"
fi
