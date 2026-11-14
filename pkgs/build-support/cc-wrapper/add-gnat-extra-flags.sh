# See add-flags.sh in cc-wrapper for comments.
accumulateRoles
mangleVarList NIX_GNATMAKE_CARGS ${role_suffixes[@]+"${role_suffixes[@]}"}

# `-B@out@/bin' forces cc to use wrapped as instead of the system one.
wrapper_NIX_GNATMAKE_CARGS="$wrapper_NIX_GNATMAKE_CARGS -B@out@/bin/"

# Only add darwin min version flag if a default darwin min version is set,
# which is a signal that we're targetting darwin.
if [ "@darwinMinVersion@" ]; then
    wrapper_NIX_GNATMAKE_CARGS="-m@darwinPlatformForCC@-version-min=${wrapper_@darwinMinVersionVariable@:-@darwinMinVersion@} $wrapper_NIX_GNATMAKE_CARGS"
fi
