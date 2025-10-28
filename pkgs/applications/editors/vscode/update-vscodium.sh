#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils jq common-updater-scripts

set -eou pipefail

latestVersion=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/VSCodium/vscodium/releases/latest | jq -r ".tag_name")
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; vscodium.version or (lib.getVersion vscodium)" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for i in \
    "x86_64-linux linux-x64 tar.gz" \
    "aarch64-linux linux-arm64 tar.gz" \
    "armv7l-linux linux-armhf tar.gz" \
    "aarch64-darwin darwin-arm64 zip" \
    "x86_64-darwin darwin-x64 zip"; do
    set -- $i
    hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $(nix-prefetch-url "https://github.com/VSCodium/vscodium/releases/download/$latestVersion/VSCodium-$2-$latestVersion.$3"))
    update-source-version vscodium $latestVersion $hash --system=$1 --ignore-same-version
done
