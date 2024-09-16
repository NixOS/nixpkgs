maturinBuildHook() {
    echo "Executing maturinBuildHook"

    runHook preBuild

    # Put the wheel to dist/ so that regular Python tooling can find it.
    local dist="$PWD/dist"

    if [ ! -z "${buildAndTestSubdir-}" ]; then
        pushd "${buildAndTestSubdir}"
    fi

    (
    set -x
    @setEnv@ maturin build \
        --jobs=$NIX_BUILD_CORES \
        --offline \
        --target @rustTargetPlatformSpec@ \
        --manylinux off \
        --strip \
        --release \
        --out "$dist" \
        ${maturinBuildFlags-}
    )

    if [ ! -z "${buildAndTestSubdir-}" ]; then
        popd
    fi

    # These are python build hooks and may depend on ./dist
    runHook postBuild

    echo "Finished maturinBuildHook"
}

buildPhase=maturinBuildHook
