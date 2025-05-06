#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch jq

set -e

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

updateHash()
{
    version=$1
    arch=$2
    os=$3

    hashKey="${arch}-${os}_hash"

    url="https://github.com/Ombi-app/Ombi/releases/download/v$version/$os-$arch.tar.gz"
    hash=$(nix-prefetch-url --type sha256 $url)
    sriHash="$(nix hash to-sri --type sha256 $hash)"

    sed -i "s|$hashKey = \"[a-zA-Z0-9\/+-=]*\";|$hashKey = \"$sriHash\";|g" "${SCRIPT_DIRECTORY}/default.nix"
}

updateVersion()
{
    sed -i "s/version = \"[0-9.]*\";/version = \"$1\";/g" "${SCRIPT_DIRECTORY}/default.nix"
}

currentVersion=$(cd ${SCRIPT_DIRECTORY} && nix eval --raw -f ../../.. ombi.version)

latestTag=$(curl https://api.github.com/repos/Ombi-App/Ombi/releases/latest | jq -r ".tag_name")
latestVersion="$(expr $latestTag : 'v\(.*\)')"

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "Ombi is up-to-date: ${currentVersion}"
    exit 0
fi

updateVersion $latestVersion

updateHash $latestVersion x64 linux
updateHash $latestVersion arm64 linux
updateHash $latestVersion x64 osx
