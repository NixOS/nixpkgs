#!/usr/bin/env nix-shell
#!nix-shell -i bash --pure -p cacert curl gnused jq nix-prefetch-github prefetch-yarn-deps nix git

set -ex

pname=mqttx-cli
owner=emqx
repo=MQTTX
dirname=$(dirname "$0")

evalProp()
{
    prop=$1
    (cd "$dirname" && nix eval --raw -f ../../../.. "$pname.$prop")
}

updateSrcHash()
{
    version=$1
    prevHash=$(evalProp src.outputHash)
    hash=$(nix-prefetch-github --rev "v$version" $owner $repo | jq '.hash' -r)
    sed -i "s|$prevHash|$hash|g" "$dirname/package.nix"
}

updateVersion()
{
    prevVersion=$(evalProp version)
    sed -i "s|$prevVersion|$1|g" "$dirname/package.nix"
}

updatePackageJson()
{
    version=$1
    url="https://raw.githubusercontent.com/$owner/$repo/v$version/cli/package.json"
    curl "$url" -L -o "$dirname/package.json"
}

updateYarnHash()
{
    version=$1
    url="https://raw.githubusercontent.com/$owner/$repo/v$version/cli/yarn.lock"
    prevHash=$(evalProp offlineCache.outputHash)
    hash32=$(prefetch-yarn-deps <(curl -L "$url"))
    hash=$(nix-hash --to-base64 --type sha256 --sri "$hash32")
    sed -i "s|$prevHash|$hash|g" "$dirname/package.nix"
}

currentVersion=$(evalProp version)

latestTag=$(curl "https://api.github.com/repos/$owner/$repo/releases/latest" | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "$repo is up-to-date: ${currentVersion}"
    exit 0
fi

updateVersion "$latestVersion"
updateSrcHash "$latestVersion"
updatePackageJson "$latestVersion"
updateYarnHash "$latestVersion"
