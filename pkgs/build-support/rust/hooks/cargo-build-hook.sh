declare -a cargoBuildFlags

cargoBuildHook() {
    echo "Executing cargoBuildHook"

    runHook preBuild

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
        --frozen \
        ${cargoBuildProfileFlag} \
        ${cargoBuildNoDefaultFeaturesFlag} \
        ${cargoBuildFeaturesFlag} \
        ${cargoBuildFlags}
    )

    if [ ! -z "${buildAndTestSubdir-}" ]; then
        popd
    fi

    runHook postBuild

    echo "Finished cargoBuildHook"
}

if [ -z "${dontCargoBuild-}" ] && [ -z "${buildPhase-}" ]; then
  buildPhase=cargoBuildHook
fi
