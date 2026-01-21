# shellcheck shell=bash disable=SC2154

cargocBuildHook() {
    echo "Executing cargocBuildHook"

    # Let stdenv handle stripping, for consistency and to not break
    # separateDebugInfo.
    export "CARGO_PROFILE_${cargoBuildType@U}_STRIP"=false

    if [ -n "${buildAndTestSubdir-}" ]; then
        # ensure the output doesn't end up in the subdirectory
        CARGO_TARGET_DIR="$(pwd)/target"
        export CARGO_TARGET_DIR

        pushd "${buildAndTestSubdir}" || exit
    fi

    local flagsArray=()

    flagsArray+=(
        "-j$NIX_BUILD_CORES"
        "--target=@rustcTargetSpec@"
        "--frozen"
    )

    if [ "${cargoBuildType}" != "debug" ]; then
        flagsArray+=("--profile" "${cargoBuildType}")
    fi

    if [ -n "${cargoBuildNoDefaultFeatures-}" ]; then
        flagsArray+=("--no-default-features")
    fi

    if [ -n "${cargoBuildFeatures-}" ]; then
        flagsArray+=("--features=$(concatStringsSep "," cargoBuildFeatures)")
    fi

    concatTo flagsArray cargoCFlags

    echoCmd 'cargocBuildHook flags' "${flagsArray[@]}"

    @setEnv@ cargo cbuild "${flagsArray[@]}"

    echo "Finished cargocBuildHook"
}

cargocCheckHook() {
    echo "Executing cargocCheckHook"

    # Let stdenv handle stripping, for consistency and to not break
    # separateDebugInfo.
    export "CARGO_PROFILE_${cargoBuildType@U}_STRIP"=false

    if [ -n "${buildAndTestSubdir-}" ]; then
        # ensure the output doesn't end up in the subdirectory
        CARGO_TARGET_DIR="$(pwd)/target"
        export CARGO_TARGET_DIR

        pushd "${buildAndTestSubdir}" || exit
    fi

    local flagsArray=()

    flagsArray+=(
        "-j$NIX_BUILD_CORES"
        "--target=@rustcTargetSpec@"
        "--frozen"
    )

    if [ "${cargoBuildType}" != "debug" ]; then
        flagsArray+=("--profile" "${cargoBuildType}")
    fi

    if [ -n "${cargoBuildNoDefaultFeatures-}" ]; then
        flagsArray+=("--no-default-features")
    fi

    if [ -n "${cargoBuildFeatures-}" ]; then
        flagsArray+=("--features=$(concatStringsSep "," cargoBuildFeatures)")
    fi

    concatTo flagsArray cargoCFlags

    echoCmd 'cargocCheckHook flags' "${flagsArray[@]}"

    @setEnv@ cargo ctest "${flagsArray[@]}"

    echo "Finished cargocCheckHook"
}

cargocInstallHook() {
    echo "Executing cargocInstallHook"

    # Let stdenv handle stripping, for consistency and to not break
    # separateDebugInfo.
    export "CARGO_PROFILE_${cargoBuildType@U}_STRIP"=false

    if [ -n "${buildAndTestSubdir-}" ]; then
        # ensure the output doesn't end up in the subdirectory
        CARGO_TARGET_DIR="$(pwd)/target"
        export CARGO_TARGET_DIR

        pushd "${buildAndTestSubdir}" || exit
    fi

    local flagsArray=()

    if [ -z "${dontAddPrefix-}" ]; then
        flagsArray+=("--prefix=$prefix")
    fi

    flagsArray+=(
        "-j$NIX_BUILD_CORES"
        "--target=@rustcTargetSpec@"
        "--frozen"
        "--libdir=${!outputLib}/lib"
        "--includedir=${!outputInclude}/include"
        "--bindir=${!outputBin}/bin"
        "--pkgconfigdir=${!outputDev}/lib/pkgconfig"
        "--datarootdir=${!outputBin}/share"
        "--datadir=${!outputBin}/share"
    )

    if [ "${cargoBuildType}" != "debug" ]; then
        flagsArray+=("--profile" "${cargoBuildType}")
    fi

    if [ -n "${cargoBuildNoDefaultFeatures-}" ]; then
        flagsArray+=("--no-default-features")
    fi

    if [ -n "${cargoBuildFeatures-}" ]; then
        flagsArray+=("--features=$(concatStringsSep "," cargoBuildFeatures)")
    fi

    concatTo flagsArray cargoCFlags

    echoCmd 'cargocInstallHook flags' "${flagsArray[@]}"

    @setEnv@ cargo cinstall "${flagsArray[@]}"

    echo "Finished cargocInstallHook"
}

if [ -z "${dontUseCargocBuild-}" ]; then
    postBuildHooks+=(cargocBuildHook)
fi

if [ -z "${dontUseCargocCheck-}" ]; then
    postCheckHooks+=(cargocCheckHook)
fi

if [ -z "${dontUseCargocInstall-}" ]; then
    postInstallHooks+=(cargocInstallHook)
fi
