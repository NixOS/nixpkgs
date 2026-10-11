accumulateRoles

# Only set up `DEVELOPER_DIR` if a default darwin min version is set,
# which is a signal that we're targetting darwin.
if [[ "@darwinMinVersion@" ]]; then
    # `DEVELOPER_DIR` is used to dynamically locate libSystem (and the SDK frameworks) based on the SDK at that path.
    # Allow wrapped compilers to do something useful when no `DEVELOPER_DIR` is set, which can happen when
    # the compiler is run outside of a stdenv or intentionally in an environment with no environment variables set.
    export DEVELOPER_DIR=${DEVELOPER_DIR_@suffixSalt@:-${DEVELOPER_DIR:-@fallback_sdk@}}

    # fallback to the hardcoded SDK for this wrapper if expected platform directory does not exist.
    if [[ ! -d "$DEVELOPER_DIR/Platforms/@xcodePlatform@.platform" ]]; then
        export DEVELOPER_DIR=@fallback_sdk@
    fi

    # Only mangle DEVELOPER_DIR after resolving the correct value.
    # This way mangleVarSingle stores the final platform SDK path, not a
    # polluted value from a cross-compilation peer SDK's setup hook.
    mangleVarSingle DEVELOPER_DIR ${role_suffixes[@]+"${role_suffixes[@]}"}

    # xcbuild needs `SDKROOT` to be the name of the SDK, which it sets in its own wrapper,
    # but compilers expect it to point to the absolute path.
    export SDKROOT="$DEVELOPER_DIR/Platforms/@xcodePlatform@.platform/Developer/SDKs/@xcodePlatform@.sdk"

    export @darwinMinVersionVariable@=${@darwinMinVersionVariable@:-@darwinMinVersion@}
fi
