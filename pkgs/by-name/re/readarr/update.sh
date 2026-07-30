#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch jq

set -e

dirname="$(dirname "$0")"

updateHash()
{
    version=$1
    arch=$2
    os=$3

    hashKey="${arch}-${os}_hash"

    url="https://github.com/Readarr/Readarr/releases/download/v$version/Readarr.develop.$version.$os-core-$arch.tar.gz"
    hash=$(nix-prefetch-url --type sha256 $url)
    sriHash="$(nix --extra-experimental-features nix-command hash to-sri --type sha256 $hash)"

    sed -i "s|$hashKey = \"[a-zA-Z0-9\/+-=]*\";|$hashKey = \"$sriHash\";|g" "$dirname/package.nix"
}

updateVersion()
{
    sed -i "s/version = \"[0-9.]*\";/version = \"$1\";/g" "$dirname/package.nix"
}

currentVersion=$(cd $dirname && nix eval --raw -f ../../../.. readarr.version)

# We cannot use the latest releases as in the past Readarr released old version with v2.0 and then went back to 0.1
latestTag=$(curl https://api.github.com/repos/Readarr/Readarr/releases | jq -r ".[0].tag_name")
latestVersion="$(expr $latestTag : 'v\(.*\)')"

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "Readarr is up-to-date: ${currentVersion}"
    exit 0
fi

updateVersion $latestVersion

updateHash $latestVersion x64 linux
updateHash $latestVersion arm64 linux
updateHash $latestVersion x64 osx

