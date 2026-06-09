#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts curl jq nix

set -euo pipefail

attr=ona-cli
manifest_url="https://releases.gitpod.io/cli/stable/manifest.json"

current_version=$(nix-instantiate --eval -E "with import ./. {}; ${attr}.version or (lib.getVersion ${attr})" | tr -d '"')
latest_version=$(curl --fail --silent --show-error --location "$manifest_url" | jq --raw-output '.version')

if [[ "$current_version" == "$latest_version" ]]; then
    echo "package is up-to-date: $current_version"
    exit 0
fi

update-source-version "$attr" "$latest_version" || true

for system in \
    aarch64-darwin \
    aarch64-linux \
    x86_64-darwin \
    x86_64-linux; do
    url=$(nix-instantiate --eval -E "with import ./. {}; ${attr}.src.url" --system "$system" | tr -d '"')
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$(nix-prefetch-url "$url")")
    update-source-version "$attr" "$latest_version" "$hash" --system="$system" --ignore-same-version
done
