#!/usr/bin/env nix-shell
# shellcheck shell=bash
#!nix-shell -i bash -p bash curl gnused jq nix

set -euo pipefail

packageNix="$(dirname "$0")/package.nix"

manifest=$(curl -fsSL https://ix.dev/cli/manifest.json)
date=$(jq -r '."channel-version"' <<< "$manifest" | cut -d T -f 1)
latestVersion="0-unstable-$date"

currentVersion=$(nix-instantiate --eval --raw -E "with import ./. {}; ix.version")
if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

declare -A platforms=(
    [x86_64-linux]=linux-x86_64
    [aarch64-linux]=linux-arm64
    [aarch64-darwin]=darwin-arm64
)

sed -i -E "s|(version = \")[^\"]+|\1$latestVersion|" "$packageNix"
for system in "${!platforms[@]}"; do
    platform=${platforms[$system]}
    digest=$(jq -er ".\"$platform\"" <<< "$manifest")
    sri=$(nix hash convert --hash-algo sha256 --to sri "$digest")
    sed -i -E "s|(cli/$platform/sha256/)[0-9a-f]{64}|\1$digest|" "$packageNix"
    sed -i -E "\|cli/$platform/|,\|hash = | s|(hash = \")[^\"]+|\1$sri|" "$packageNix"
done
