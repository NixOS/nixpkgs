#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils jq common-updater-scripts

set -eou pipefail

latestVersion=$(curl -Ls 'https://data.services.jetbrains.com/products?code=TBA&release.type=release' | jq -r '.[0].releases | flatten | .[0].build')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; jetbrains-toolbox.version or (lib.getVersion jetbrains-toolbox)" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

linux_systems=(
    "x86_64-linux:"
    "aarch64-linux:-arm64"
)

for entry in "${linux_systems[@]}"; do
    arch="${entry%%:*}"
    suffix="${entry#*:}"
    prefetch=$(nix-prefetch-url --unpack "https://download.jetbrains.com/toolbox/jetbrains-toolbox-$latestVersion$suffix.tar.gz")
    hash=$(nix hash convert --hash-algo sha256 --to sri $prefetch)
    update-source-version jetbrains-toolbox $latestVersion $hash --system=$arch --ignore-same-version
done

darwin_systems=(
    "x86_64-darwin:"
    "aarch64-darwin:-arm64"
)

for entry in "${darwin_systems[@]}"; do
    arch="${entry%%:*}"
    suffix="${entry#*:}"
    prefetch=$(nix-prefetch-url "https://download.jetbrains.com/toolbox/jetbrains-toolbox-$latestVersion$suffix.dmg")
    hash=$(nix hash convert --hash-algo sha256 --to sri $prefetch)
    update-source-version jetbrains-toolbox $latestVersion $hash --system=$arch --ignore-same-version
done
