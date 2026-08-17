#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch

set -o errexit
set -o nounset
set -o pipefail

dirname="$(dirname "$0")"

updateHash()
{
    version=$1
    archHash=$2
    filetype=$3

    url="https://sprites-binaries.t3.storage.dev/client/v$version/sprite-$filetype.tar.gz"
    hash=$(nix-prefetch-url --type sha256 "$url")
    sriHash="$(nix hash convert sha256:"$hash")"

    sed -i "s|$archHash = \"[a-zA-Z0-9\/+-=]*\";|$archHash = \"$sriHash\";|g" "$dirname/package.nix"
}

updateVersion()
{
    sed -i "s/version = \".*\";/version = \"$1\";/g" "$dirname/package.nix"
}

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; sprite.version" | tr -d '"')

# right now, the release channel returns an error, because no "stable" version
# has been released; we have to rely on the release candidate for now.
# TODO: drop /rc.txt when a release hits stable
latestTag=$(curl -f https://sprites-binaries.t3.storage.dev/client/release.txt \
         || curl -f https://sprites-binaries.t3.storage.dev/client/rc.txt)
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "sprite is up-to-date: ${currentVersion}"
    exit 0
fi

updateVersion "$latestVersion"

updateHash "$latestVersion" x86_64-linux   linux-amd64
updateHash "$latestVersion" aarch64-linux  linux-arm64
updateHash "$latestVersion" x86_64-darwin  darwin-amd64
updateHash "$latestVersion" aarch64-darwin darwin-arm64
