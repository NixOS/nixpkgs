# shellcheck shell=bash disable=SC2034,SC2154,SC2164

# We replace these
export dontCargoBuild=true
export dontCargoInstall=true

tauriBuildHook() {
    echo "Executing tauriBuildHook"

    runHook preBuild

    ## The following is lifted from rustPlatform.cargoBuildHook
    ## As we're replacing it, we should also be respecting its options.

    # Account for running outside of mkRustPackage where this may not be set
    cargoBuildType="${cargoBuildType:-release}"

    # Let stdenv handle stripping, for consistency and to not break
    # separateDebugInfo.
    export "CARGO_PROFILE_${cargoBuildType@U}_STRIP"=false

    if [ -n "${buildAndTestSubdir-}" ]; then
        # ensure the output doesn't end up in the subdirectory
        CARGO_TARGET_DIR="$(pwd)/target"
        export CARGO_TARGET_DIR

        # Tauri doesn't respect $CARGO_TARGET_DIR, but does respect the cargo
        # argument...but that doesn't respect `--target`, so we have to use the
        # config file
        # https://github.com/tauri-apps/tauri/issues/10190
        printf '\nbuild.target-dir = "%s"' "$CARGO_TARGET_DIR" >>config.toml

        pushd "${buildAndTestSubdir}"
    fi

    local cargoFlagsArray=(
        "-j" "$NIX_BUILD_CORES"
        "--target" "@rustHostPlatformSpec@"
        "--offline"
    )
    local tauriFlagsArray=(
        "--bundles" "${tauriBundleType:-@defaultTauriBundleType@}"
        "--target" "@rustHostPlatformSpec@"
    )

    if [ "${cargoBuildType}" != "debug" ]; then
        cargoFlagsArray+=("--profile" "${cargoBuildType}")
    fi

    if [ -n "${cargoBuildNoDefaultFeatures-}" ]; then
        cargoFlagsArray+=("--no-default-features")
    fi

    if [ -n "${cargoBuildFeatures-}" ]; then
        cargoFlagsArray+=("--features=$(concatStringsSep "," cargoBuildFeatures)")
    fi

    concatTo cargoFlagsArray cargoBuildFlags

    if [ "${cargoBuildType:-}" == "debug" ]; then
        tauriFlagsArray+=("--debug")
    fi

    concatTo tauriFlagsArray tauriBuildFlags

    echoCmd 'cargo-tauri.hook cargoFlags' "${cargoFlagsArray[@]}"
    echoCmd 'cargo-tauri.hook tauriFlags' "${tauriFlagsArray[@]}"

    @setEnv@ cargo tauri build "${tauriFlagsArray[@]}" -- "${cargoFlagsArray[@]}"

    if [ -n "${buildAndTestSubdir-}" ]; then
        popd
    fi

    runHook postBuild

    echo "Finished tauriBuildHook"
}

tauriInstallHook() {
    echo "Executing tauriInstallHook"

    runHook preInstall

    # Use a nice variable for our target directory in the following script
    targetDir=target/@targetSubdirectory@/$cargoBuildType

    @installScript@

    runHook postInstall

    echo "Finished tauriInstallHook"
}

if [ -z "${dontTauriBuild:-}" ] && [ -z "${buildPhase:-}" ]; then
    buildPhase=tauriBuildHook
fi

if [ -z "${dontTauriInstall:-}" ] && [ -z "${installPhase:-}" ]; then
    installPhase=tauriInstallHook
fi
