accumulateRoles

# Select the SDK using the same consistency rule as other singular inputs.
# Publish its tool environment before hooks; retain raw inputs for fresh children.
if [[ "@darwinMinVersion@" ]]; then
    restoreProjectedVar DEVELOPER_DIR
    mangleVarSingle DEVELOPER_DIR ${role_suffixes[@]+"${role_suffixes[@]}"}
    wrapper_DEVELOPER_DIR=${wrapper_DEVELOPER_DIR:-@fallback_sdk@}

    # xcbuild uses an SDK name; compilers require the absolute SDK path.
    wrapper_SDKROOT="$wrapper_DEVELOPER_DIR/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
    exportProjectedVar DEVELOPER_DIR "$wrapper_DEVELOPER_DIR"
    export SDKROOT="$wrapper_SDKROOT"
fi
