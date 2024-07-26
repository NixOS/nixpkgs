#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p jq nix-prefetch-scripts

set -euo pipefail

DEFAULT_NIX="$(realpath "./pkgs/applications/editors/android-studio/default.nix")"
RELEASES_JSON="$(curl --silent -L https://jb.gg/android-studio-releases-list.json)"

# Available channels: Release/Patch (stable), Beta, Canary
getLatest() {
    local attribute="$1"
    local channel="$2"
    case "$channel" in
        "stable") local select='.channel == "Release" or .channel == "Patch"' ;;
        "beta") local select='.channel == "Beta" or .channel == "RC"' ;;
        *) local select=".channel == \"${channel^}\"" ;;
    esac
    local result="$(echo "$RELEASES_JSON" \
        | jq -r ".content.item[] | select(${select}) | [.version, .${attribute}] | join(\" \")" \
        | sort --version-sort \
        | cut -d' ' -f 2- \
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

    local localVersion="$(nix --extra-experimental-features nix-command eval --raw --file . androidStudioPackages."${channel}".version)"
    if [[ "${latestVersion}" == "${localVersion}" ]]; then
        echo "$channel is already up to date at $latestVersion"
        return 0
    fi
    echo "updating $channel from $localVersion to $latestVersion"

    local latestHash="$(nix-prefetch-url "https://dl.google.com/dl/android/studio/ide-zips/${latestVersion}/android-studio-${latestVersion}-linux.tar.gz")"
    local latestSri="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$latestHash")"
    local localHash="$(nix --extra-experimental-features nix-command eval --raw --file . androidStudioPackages."${channel}".unwrapped.src.drvAttrs.outputHash)"
    sed -i "s~${localHash}~${latestSri}~g" "${DEFAULT_NIX}"

    # Match the formatting of default.nix: `version = "2021.3.1.14"; # "Android Studio Dolphin (2021.3.1) Beta 5"`
    local versionString="${latestVersion}\"; # \"$(getLatest "name" "${channel}")\""
    sed -i "s~${localVersion}.*~${versionString}~g" "${DEFAULT_NIX}"
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
