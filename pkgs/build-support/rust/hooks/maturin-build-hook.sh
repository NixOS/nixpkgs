maturinBuildHook() {
    echo "Executing maturinBuildHook"

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
      maturin build \
        --jobs=$NIX_BUILD_CORES \
        --frozen \
        --target @rustTargetPlatformSpec@ \
        --manylinux off \
        --strip \
        --release \
        ${maturinBuildFlags-}
    )

    runHook postBuild

    if [ ! -z "${buildAndTestSubdir-}" ]; then
        popd
    fi

    # Move the wheel to dist/ so that regular Python tooling can find it.
    mkdir -p dist
    mv target/wheels/*.whl dist/

    echo "Finished maturinBuildHook"
}

buildPhase=maturinBuildHook
