#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch jq

set -euo pipefail

dirname="$(dirname "$(readlink -f "$0")")"

updateHash() {
    local version arch os
    version="$1"
    arch="$2"
    os="$3"

    local url hash sriHash
    url="https://github.com/Lidarr/Lidarr/releases/download/v$version/Lidarr.master.$version.$os-core-$arch.tar.gz"
    hash="$(nix-prefetch-url --type sha256 "$url")"
    sriHash="$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$hash")"

    local hashKey="${arch}-${os}_hash"
    sed -i "s|$hashKey = \"[a-zA-Z0-9\/+-=]*\";|$hashKey = \"$sriHash\";|g" "$dirname/package.nix"
}

updateVersion() {
    sed -i "s/version = \"[0-9.]*\";/version = \"$1\";/g" "$dirname/package.nix"
}

latestTag=$(curl https://api.github.com/repos/Lidarr/Lidarr/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"

updateVersion "$latestVersion"

updateHash "$latestVersion" x64 linux
updateHash "$latestVersion" arm64 linux
updateHash "$latestVersion" x64 osx
updateHash "$latestVersion" arm64 osx
