#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nix common-updater-scripts

set -euo pipefail

latestVersion=$(curl -Ls https://mochi.cards/ | grep -oP 'Mochi-\K[0-9]+\.[0-9]+\.[0-9]+(?=\.AppImage)' | head -1)
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; mochi.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

# Update version and hash for x86_64-linux (AppImage)
update-source-version mochi "$latestVersion" --system=x86_64-linux

# Update hashes for darwin systems
for system in x86_64-darwin aarch64-darwin; do
    url=$(nix-instantiate --eval --json -E "with import ./. { system = \"$system\"; }; mochi.src.url" | tr -d '"')
    hash=$(nix-prefetch-url "$url")
    sriHash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$hash")
    update-source-version mochi "$latestVersion" "$sriHash" --system="$system" --ignore-same-version
done
