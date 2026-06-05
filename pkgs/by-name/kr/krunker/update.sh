#!/usr/bin/env nix-shell
#! nix-shell --pure -i bash -p bash cacert common-updater-scripts curl yq
# shellcheck shell=bash
set -euo pipefail

root=$(readlink -f "$0" | xargs dirname)
script_name="krunker-update"
updater_url="client2.krunker.io"

log() {
    echo "$script_name: $*"
}

panic() {
    log "$*"
    exit 1
}

update() {
    platform="${1:-}"
    if [ -z "$platform" ]; then
        panic "error: a platform must be supplied to \`update()\`!"
    fi

    nixfile="$root"/"$platform".nix
    if [ ! -f "$nixfile" ]; then
        panic "error: $platform is not supported!"
    fi

    electron_suffix=""
    system="x86_64-linux"
    if [ "$platform" == "darwin" ]; then
        electron_suffix="-mac"
        system="aarch64-darwin"
    elif [ "$platform" == "linux" ]; then
        electron_suffix="-linux"
    fi

    url="https://$updater_url/latest${electron_suffix}.yml"
    log "fetching update information from from $url"
    response="$(curl -sSL "$url")"
    version="$(yq --raw-output '.version' <<<"$response")"
    sha512="$(yq \
        --raw-output \
        '.files | map(select(.url | contains("dmg") or contains("AppImage"))) | first | .sha512' \
        <<<"$response")"

    update-source-version krunker "$version" sha512-"$sha512" --file="$nixfile" --system="$system"
}

supported_platforms=(
    "darwin"
    "linux"
)

for platform in "${supported_platforms[@]}"; do
    update "$platform"
done
