#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
#shellcheck shell=bash

set -eu -o pipefail

release_data=$(curl -sSfL "https://api.github.com/repos/stablyai/orca/releases/latest")
version=$(jq -r '.tag_name[1:]' <<<"$release_data")

# GitHub records a SHA-256 digest for every release asset at upload time, so the
# hashes can be read from the API instead of downloading ~390 MiB of AppImages.
asset_hash() {
    local digest
    digest=$(jq -r --arg name "$1" '.assets[] | select(.name == $name) | .digest' <<<"$release_data")
    if [[ $digest != sha256:* ]]; then
        echo "orca-ide: no sha256 digest published for asset '$1'" >&2
        return 1
    fi
    nix-hash --to-sri --type sha256 "${digest#sha256:}"
}

hash_x86_64=$(asset_hash "orca-linux.AppImage")
hash_aarch64=$(asset_hash "orca-linux-arm64.AppImage")

update-source-version orca-ide "$version" "$hash_x86_64" \
    --system=x86_64-linux --ignore-same-version
update-source-version orca-ide "$version" "$hash_aarch64" \
    --system=aarch64-linux --ignore-same-version
