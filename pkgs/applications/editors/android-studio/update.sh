#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p python3Packages.yq nix-prefetch-scripts

set -euo pipefail

DEFAULT_NIX="$(realpath "./pkgs/applications/editors/android-studio/default.nix")"
RELEASES_XML="$(curl -v --silent https://raw.githubusercontent.com/JetBrains/intellij-sdk-docs/main/topics/_generated/android_studio_releases.xml 2>/dev/null)"

# Available channels: Release/Patch (stable), Beta, Canary
getLatest() {
    local attribute="$1"
    local channel="$2"
    [[ "$channel" = "stable" ]] && channel="release" # Our naming convention is different
    local result="$(echo "$RELEASES_XML" \
        | xq -r ".[].item[] | select(.channel == \"${channel^}\") | .${attribute}" \
        | sort --version-sort \
        | tail -n 1)"

    if [[ -n "$result" ]]; then
        echo "$result"
    else
        echo "could not find the latest $attribute for $channel"
        exit 1
    fi
}

updateChannel() {
    local channel="$1"
    local latestVersion="$(getLatest "version" "$channel")"
    if [[ "$channel" = "stable" ]]; then
        # Sometimes the latest stable version is published under the `patch` channel instead of `release`,
        # so we need to check if the latest version of the release channel isnt older than the patch channel
        local latestPatchVersion="$(getLatest "version" "patch")"
        if [[ "$(nix eval --expr "with import ./default.nix {}; lib.versionOlder \"${latestVersion}\" \"${latestPatchVersion}\"" --impure)" = "true" ]]; then
            latestVersion="$latestPatchVersion"
        fi
    fi

    local localVersion="$(nix eval --raw --file . androidStudioPackages."${channel}".version)"
    if [[ "${latestVersion}" == "${localVersion}" ]]; then
        echo "$channel is already up to date!"
        return 0
    fi
    echo "updating $channel from $localVersion to $latestVersion"

    local latestHash="$(nix-prefetch-url --quiet "https://dl.google.com/dl/android/studio/ide-zips/${latestVersion}/android-studio-${latestVersion}-linux.tar.gz")"
    local localHash="$(nix eval --raw --file . androidStudioPackages."${channel}".unwrapped.src.drvAttrs.outputHash)"
    sed -i "s/${localHash}/${latestHash}/g" "${DEFAULT_NIX}"

    # Match the formatting of default.nix: `version = "2021.3.1.14"; # "Android Studio Dolphin (2021.3.1) Beta 5"`
    local versionString="${latestVersion}\"; # \"$(getLatest "name" "${channel}")\""
    sed -i "s/${localVersion}.*/${versionString}/g" "${DEFAULT_NIX}"
    echo "updated ${channel} to ${latestVersion}"
}

if (( $# == 0 )); then
    for channel in "beta" "canary" "stable"; do
        updateChannel "$channel"
    done
else
    while (( "$#" )); do
        case "$1" in
            beta|canary|stable)
                updateChannel "$1" ;;
            *)
                echo "unknown channel: $1" && exit 1 ;;
        esac
        shift 1
    done
fi
