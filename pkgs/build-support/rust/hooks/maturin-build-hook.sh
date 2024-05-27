maturinBuildHook() {
    echo "Executing maturinBuildHook"

    runHook preBuild

    if [ ! -z "${buildAndTestSubdir-}" ]; then
        pushd "${buildAndTestSubdir}"
    fi

    (
    set -x
    @setEnv@ maturin build \
        --jobs=$NIX_BUILD_CORES \
        --frozen \
        --target @rustTargetPlatformSpec@ \
        --manylinux off \
        --strip \
        --release \
        ${maturinBuildFlags-}
    )

    if [ ! -z "${buildAndTestSubdir-}" ]; then
        popd
    fi

    # Move the wheel to dist/ so that regular Python tooling can find it.
    mkdir -p dist
    mv ${cargoRoot:+$cargoRoot/}target/wheels/*.whl dist/

    # These are python build hooks and may depend on ./dist
    runHook postBuild

    echo "Finished maturinBuildHook"
}

buildPhase=maturinBuildHook
