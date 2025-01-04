# See add-flags.sh in cc-wrapper for comments.
var_templates_list=(
    NIX_GNATMAKE_CARGS
)

accumulateRoles

for var in "${var_templates_list[@]}"; do
    mangleVarList "$var" ${role_suffixes[@]+"${role_suffixes[@]}"}
done

# `-B@out@/bin' forces cc to use wrapped as instead of the system one.
NIX_GNATMAKE_CARGS_@suffixSalt@="$NIX_GNATMAKE_CARGS_@suffixSalt@ -B@out@/bin/"

# Only add darwin min version flag if a default darwin min version is set,
# which is a signal that we're targetting darwin.
if [ "@darwinMinVersion@" ]; then
    mangleVarSingle @darwinMinVersionVariable@ ${role_suffixes[@]+"${role_suffixes[@]}"}

    NIX_GNATMAKE_CARGS_@suffixSalt@="-m@darwinPlatformForCC@-version-min=${@darwinMinVersionVariable@_@suffixSalt@:-@darwinMinVersion@} $NIX_GNATMAKE_CARGS_@suffixSalt@"
fi

export NIX_GNAT_WRAPPER_EXTRA_FLAGS_SET_@suffixSalt@=1
