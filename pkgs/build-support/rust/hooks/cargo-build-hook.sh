declare -a cargoBuildFlags

cargoBuildHook() {
    echo "Executing cargoBuildHook"

    runHook preBuild

    if [ ! -z "${buildAndTestSubdir-}" ]; then
        pushd "${buildAndTestSubdir}"
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
        --${cargoBuildType} \
        ${cargoBuildFlags}
    )

    if [ ! -z "${buildAndTestSubdir-}" ]; then
        popd
    fi

    runHook postBuild

    echo "Finished cargoBuildHook"
}

buildPhase=cargoBuildHook
