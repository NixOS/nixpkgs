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
        cargoBuildProfileFlag="--${cargoBuildType}"
    fi

    if [ -n "${cargoBuildNoDefaultFeatures-}" ]; then
        cargoBuildNoDefaultFeaturesFlag=--no-default-features
    fi

    if [ -n "${cargoBuildFeatures-}" ]; then
        cargoBuildFeaturesFlag="--features=${cargoBuildFeatures// /,}"
    fi

    (
    set -x
    env \
      "CC_@rustBuildPlatform@=@ccForBuild@" \
      "CXX_@rustBuildPlatform@=@cxxForBuild@" \
      "CC_@rustTargetPlatform@=@ccForHost@" \
      "CXX_@rustTargetPlatform@=@cxxForHost@" \
      cargo build -j $NIX_BUILD_CORES \
        --target @rustTargetPlatformSpec@ \
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
