#!/usr/bin/env nix-shell
##!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts gnused nix coreutils

set -eu -o pipefail


latestVersion=$(curl -s ${GITHUB_TOKEN:+ -H "Authorization: Bearer $GITHUB_TOKEN"} https://api.github.com/repos/owncloud/ocis/releases?per_page=1 \
    | jq -r ".[0].tag_name" \
    | sed 's/^v//')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; ocis-bin.version or (lib.getVersion ocis-bin)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "ocis-bin is up-to-date: $currentVersion"
    exit 0
fi

function get_hash() {
    local os=$1
    local arch=$2
    local version=$3

    local pkg_hash=$(nix-prefetch-url --type sha256 \
        https://github.com/owncloud/ocis/releases/download/v"${version}"/ocis-"${version}"-"${os}"-"${arch}")
    nix hash to-sri "sha256:$pkg_hash"
}


update-source-version ocis-bin "$latestVersion" $(get_hash darwin arm64 "$latestVersion") --system="aarch64-darwin" --ignore-same-version
update-source-version ocis-bin "$latestVersion" $(get_hash darwin amd64 "$latestVersion") --system="x86_64-darwin" --ignore-same-version
update-source-version ocis-bin "$latestVersion" $(get_hash linux arm64 "$latestVersion") --system="aarch64-linux" --ignore-same-version
update-source-version ocis-bin "$latestVersion" $(get_hash linux arm "$latestVersion") --system="armv7l-linux" --ignore-same-version
update-source-version ocis-bin "$latestVersion" $(get_hash linux amd64 "$latestVersion") --system="x86_64-linux" --ignore-same-version
update-source-version ocis-bin "$latestVersion" $(get_hash linux 386 "$latestVersion") --system="i686-linux" --ignore-same-version
