# shellcheck shell=bash

dartInstallHook() {
    echo "Executing dartInstallHook"

    runHook preInstall

    # Install snapshots and executables.
    mkdir -p "$out"
    while IFS=$'\t' read -ra target; do
        dest="${target[0]}"
        # Wrap with runtime command, if it's defined
        if [ -n "$dartRuntimeCommand" ]; then
            install -D "$dest" "$out/share/$dest"
            makeWrapper "$dartRuntimeCommand" "$out/$dest" \
                --add-flags "$out/share/$dest"
        else
            install -Dm755 "$dest" "$out/$dest"
        fi
    done < <(_getDartEntryPoints)

    runHook postInstall

    echo "Finished dartInstallHook"
}

dartInstallCacheHook() {
    echo "Executing dartInstallCacheHook"

    # Install the package_config.json file.
    mkdir -p "$pubcache"
    cp .dart_tool/package_config.json "$pubcache/package_config.json"

    echo "Finished dartInstallCacheHook"
}

if [ -z "${dontDartInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=dartInstallHook
fi

if [ -z "${dontDartInstallCache-}" ]; then
    postInstallHooks+=(dartInstallCacheHook)
fi
