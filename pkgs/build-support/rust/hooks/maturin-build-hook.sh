# shellcheck shell=bash disable=SC2154,SC2164

maturinBuildHook() {
    echo "Executing maturinBuildHook"

    runHook preBuild

    # Put the wheel to dist/ so that regular Python tooling can find it.
    local dist="$PWD/dist"

    if [ -n "${buildAndTestSubdir-}" ]; then
        pushd "${buildAndTestSubdir}"
    fi

    local flagsArray=(
        "--jobs=$NIX_BUILD_CORES"
        "--offline"
        "--target" "@rustTargetPlatformSpec@"
        "--manylinux" "off"
        "--strip"
        "--release"
        "--out" "$dist"
    )

    concatTo flagsArray maturinBuildFlags

    echoCmd 'maturinBuildHook flags' "${flagsArray[@]}"
    @setEnv@ maturin build "${flagsArray[@]}"

    if [ -n "${buildAndTestSubdir-}" ]; then
        popd
    fi

    # These are python build hooks and may depend on ./dist
    runHook postBuild

    echo "Finished maturinBuildHook"
}

buildPhase=maturinBuildHook
