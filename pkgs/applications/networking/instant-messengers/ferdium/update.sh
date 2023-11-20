#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch jq

set -e

dirname="$(dirname "$0")"

updateHash()
{
    version=$1
    arch=$2

    hashKey="${arch}-linux_hash"

    url="https://github.com/ferdium/ferdium-app/releases/download/v$version/Ferdium-linux-$version-$arch.deb"
    hash=$(nix-prefetch-url --type sha256 $url)
    sriHash="$(nix hash to-sri --type sha256 $hash)"

    sed -i "s|$hashKey = \"[a-zA-Z0-9\/+-=]*\";|$hashKey = \"$sriHash\";|g" "$dirname/default.nix"
}

updateVersion()
{
    sed -i "s/version = \"[0-9.]*\";/version = \"$1\";/g" "$dirname/default.nix"
}

currentVersion=$(cd $dirname && nix eval --raw -f ../../../../.. ferdium.version)

latestTag=$(curl https://api.github.com/repos/ferdium/ferdium-app/releases/latest | jq -r ".tag_name")
latestVersion="$(expr $latestTag : 'v\(.*\)')"

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "Ferdium is up-to-date: ${currentVersion}"
    exit 0
fi

updateVersion $latestVersion

updateHash $latestVersion amd64
updateHash $latestVersion arm64
