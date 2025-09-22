#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl megacmd unzip common-updater-scripts

set -eu -o pipefail

ATTR=legends-of-equestria
DOWNLOADS_PAGE=https://www.legendsofequestria.com/downloads
OLD_VERSION=$(nix-instantiate --eval -A $ATTR.version | tr -d '"')
TMP=$(mktemp -d)

findHash() {
    system=$1
    url="$2"

    mkdir -p $TMP/$system/{download,out}
    oldpwd="$(pwd)"
    cd $TMP/$system

    echo "downloading to $(pwd)/download..." >&2
    HOME=$TMP mega-get "$url" download >&2
    echo "unzipping to $(pwd)/out..." >&2
    unzip -q -d out download/*.zip

    nix --extra-experimental-features nix-command hash path --sri out

    cd "$oldpwd"
}

applyUpdate() {
    system=$1
    echo "checking for updates for $system..." >&2
    systemText="$2"
    regex='<a href="(https.+)">'"$systemText"'</a>.+v(([0-9]+\.)+[0-9]+)'

    if [[ "$(curl -s $DOWNLOADS_PAGE | grep -Fi "$systemText")" =~ $regex ]]; then
        url="${BASH_REMATCH[1]}"
        version="${BASH_REMATCH[2]}"
        echo "$version $url" >&2
    else
        echo "cannot find the latest version for $system" >&2
        exit 1
    fi
    if [[ $OLD_VERSION == $version ]]; then
        echo "already up-to-date at version $version" >&2
        exit 1
    fi

    hash="$(findHash $system "$url" | sed -E 's/sha256-(.+)/\1/')"
    echo "output hash: $hash" >&2
    update-source-version $ATTR $version "$hash" "$url" --system=$system --ignore-same-version --ignore-same-hash
}

applyUpdate x86_64-linux Linux
applyUpdate x86_64-darwin macOS
applyUpdate aarch64-darwin "macOS arm64"
