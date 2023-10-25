# shellcheck shell=bash

dartInstallHook() {
    echo "Executing dartInstallHook"

    runHook preInstall

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

if [ -z "${dontDartInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=dartInstallHook
fi
