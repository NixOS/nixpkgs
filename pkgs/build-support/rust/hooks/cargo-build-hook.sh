declare -a cargoBuildFlags

cargoBuildHook() {
    echo "Executing cargoBuildHook"

    # Let stdenv handle stripping, for consistency and to not break
    # separateDebugInfo.
    export "CARGO_PROFILE_${cargoBuildType@U}_STRIP"=false

    if [ ! -z "${buildAndTestSubdir-}" ]; then
        # ensure the output doesn't end up in the subdirectory
        export CARGO_TARGET_DIR="$(pwd)/target"

        pushd "${buildAndTestSubdir}"
    fi

    if [ "${cargoBuildType}" != "debug" ]; then
        cargoBuildProfileFlag="--profile ${cargoBuildType}"
    fi

    if [ -n "${cargoBuildNoDefaultFeatures-}" ]; then
        cargoBuildNoDefaultFeaturesFlag=--no-default-features
    fi

    if [ -n "${cargoBuildFeatures-}" ]; then
        if [ -n "$__structuredAttrs" ]; then
            OLDIFS="$IFS"
            IFS=','; cargoBuildFeaturesFlag="--features=${cargoBuildFeatures[*]}"
            IFS="$OLDIFS"
            unset OLDIFS
        else
            cargoBuildFeaturesFlag="--features=${cargoBuildFeatures// /,}"
        fi
    fi

    (
    set -x
    @setEnv@ cargo build -j $NIX_BUILD_CORES \
        --target @rustHostPlatformSpec@ \
        --offline \
        ${cargoBuildProfileFlag} \
        ${cargoBuildNoDefaultFeaturesFlag} \
        ${cargoBuildFeaturesFlag} \
        ${cargoBuildFlags}
    )

    if [ ! -z "${buildAndTestSubdir-}" ]; then
        popd
    fi

    echo "Finished cargoBuildHook"
}

cargoBuildPhase() {
    runHook preBuild

    cargoBuildHook

    runHook postBuild
}

if [ -z "${dontCargoBuild-}" ]; then
    if [ -z "${buildPhase-}" ]; then
        buildPhase=cargoBuildPhase
    else
        preBuildHooks+=(cargoBuildHook)
    fi
fi
