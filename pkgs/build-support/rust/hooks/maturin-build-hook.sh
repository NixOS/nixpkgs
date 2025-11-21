# shellcheck shell=bash disable=SC2154,SC2164

maturinBuildHook() {
    echo "Executing maturinBuildHook"

    runHook preBuild

    # Put the wheel to dist/ so that regular Python tooling can find it.
    local dist="$PWD/dist"

    if [ -n "${buildAndTestSubdir-}" ]; then
        pushd "${buildAndTestSubdir}"
    fi

    # This is a huge hack, but it's the least invasive way
    # to get the required interpreter name for maturin.
    local interpreter_path="$(command -v python3 || command -v pypy3)"
    local interpreter_name="$($interpreter_path -c 'import os; import sysconfig; print(os.path.basename(sysconfig.get_config_var('\''INCLUDEPY'\'')))')"

    local flagsArray=(
        "--jobs=$NIX_BUILD_CORES"
        "--offline"
        "--target" "@rustcTargetSpec@"
        "--manylinux" "off"
        "--strip"
        "--release"
        "--out" "$dist"
        "--interpreter" "$interpreter_name"
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
