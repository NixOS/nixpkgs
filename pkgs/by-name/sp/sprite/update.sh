#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix

set -o errexit
set -o nounset
set -o pipefail

dirname="$(dirname "$0")"

getHash()
{
    local version=$1
    local platform=$2
    local url hash

    url="https://sprites.dev/dl/client/$version/sprite-$platform"
    hash=$(nix-prefetch-url --type sha256 "$url") || return
    nix hash convert --hash-algo sha256 --to sri "$hash"
}

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; sprite.version" | tr -d '"')

latestVersion=$(curl -fsSL https://sprites.dev/dl/client/latest)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "sprite is up-to-date: ${currentVersion}"
    exit 0
fi

x86_64LinuxHash=$(getHash "$latestVersion" linux-x86_64)
aarch64LinuxHash=$(getHash "$latestVersion" linux-aarch64)
aarch64DarwinHash=$(getHash "$latestVersion" macos-aarch64)

sed -i \
    -e "s|version = \".*\";|version = \"$latestVersion\";|" \
    -e "s|x86_64-linux = \".*\";|x86_64-linux = \"$x86_64LinuxHash\";|" \
    -e "s|aarch64-linux = \".*\";|aarch64-linux = \"$aarch64LinuxHash\";|" \
    -e "s|aarch64-darwin = \".*\";|aarch64-darwin = \"$aarch64DarwinHash\";|" \
    "$dirname/package.nix"
