accumulateRoles

# Only set up `DEVELOPER_DIR` if a default darwin min version is set,
# which is a signal that we're targetting darwin.
if [[ "@darwinMinVersion@" ]]; then
    # `DEVELOPER_DIR` is used to dynamically locate libSystem (and the SDK frameworks) based on the SDK at that path.
    mangleVarSingle DEVELOPER_DIR ${role_suffixes[@]+"${role_suffixes[@]}"}

    # Allow wrapped compilers to do something useful when no `DEVELOPER_DIR` is set, which can happen when
    # the compiler is run outside of a stdenv or intentionally in an environment with no environment variables set.
    export DEVELOPER_DIR=${DEVELOPER_DIR_@suffixSalt@:-@fallback_sdk@}

    # xcbuild needs `SDKROOT` to be the name of the SDK, which it sets in its own wrapper,
    # but compilers expect it to point to the absolute path.
    export SDKROOT="$DEVELOPER_DIR/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
fi
