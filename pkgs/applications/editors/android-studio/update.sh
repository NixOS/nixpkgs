#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p jq

set -euo pipefail

DEFAULT_NIX="$(realpath "./pkgs/applications/editors/android-studio/default.nix")"
RELEASES_JSON="$(curl --silent -L https://jb.gg/android-studio-releases-list.json)"
PLATFORMS=(
    "x86_64-linux|-linux.tar.gz"
    "aarch64-darwin|-mac_arm.dmg"
)

# Available channels: Release/Patch (stable), Beta, Canary
getLatest() {
    local attribute="$1"
    local channel="$2"
    case "$channel" in
        "stable") local select='.channel == "Release" or .channel == "Patch"' ;;
        "beta") local select='.channel == "Beta" or .channel == "RC"' ;;
        *) local select=".channel == \"${channel^}\"" ;;
    esac
    local result
    result="$(echo "$RELEASES_JSON" \
        | jq -r ".content.item[] | select(${select}) | [.version, (${attribute})] | join(\" \")" \
        | sort --version-sort \
        | cut -d' ' -f 2- \
        | tail -n 1)"

    if [[ -n "$result" ]]; then
        echo "$result"
    else
        echo "could not find the latest $attribute for $channel" >&2
        exit 1
    fi
}

updateChannel() {
    local channel="$1"
    local latestVersion
    latestVersion="$(getLatest ".version" "$channel")"

    local localVersion
    localVersion="$(nix --extra-experimental-features nix-command eval --raw --file . androidStudioPackages."${channel}".version)"
    if [[ "${latestVersion}" == "${localVersion}" ]]; then
        echo "$channel is already up to date at $latestVersion"
        return 0
    fi
    echo "updating $channel from $localVersion to $latestVersion"

    local platformSpec
    local replacements=()
    for platformSpec in "${PLATFORMS[@]}"; do
        local system="${platformSpec%%|*}"
        local suffix="${platformSpec#*|}"
        local latestUrl
        latestUrl="$(getLatest "[.download[] | select(.link | endswith(\"${suffix}\"))][0].link" "$channel")"
        local latestHash
        latestHash="$(getLatest "[.download[] | select(.link | endswith(\"${suffix}\"))][0].checksum" "$channel")"

        if [[ "$latestUrl" != https://edgedl.me.gvt1.com/android/studio/* ]]; then
            echo "URL '$latestUrl' had an unexpected value, maybe the server changed?" >&2
            exit 1
        fi

        local latestSri
        latestSri="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$latestHash")"
        local localUrl
        localUrl="$(nix --extra-experimental-features nix-command eval --system "$system" --json --file . androidStudioPackages."${channel}".unwrapped.src.drvAttrs.urls | jq -r '.[0]')"
        local localHash
        localHash="$(nix --extra-experimental-features nix-command eval --system "$system" --raw --file . androidStudioPackages."${channel}".unwrapped.src.drvAttrs.outputHash)"
        replacements+=("${localHash}|${latestSri}")
        replacements+=("${localUrl}|${latestUrl}")
    done

    local replacement
    for replacement in "${replacements[@]}"; do
        local oldValue="${replacement%%|*}"
        local newValue="${replacement#*|}"
        sed -i "s~${oldValue}~${newValue}~g" "${DEFAULT_NIX}"
    done

    # Match the formatting of default.nix: `version = "2021.3.1.14"; # "Android Studio Dolphin (2021.3.1) Beta 5"`
    local versionString
    versionString="${latestVersion}\"; # \"$(getLatest ".name" "${channel}")\""
    sed -i "s~${localVersion}.*~${versionString}~g" "${DEFAULT_NIX}"
    echo "updated ${channel} to ${latestVersion}" >&2
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
            dev)
                echo "no autoupdate for dev" >&2 && exit 0 ;;
            *)
                echo "unknown channel: $1" >&2 && exit 1 ;;
        esac
        shift 1
    done
fi
