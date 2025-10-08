#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl megacmd unzip common-updater-scripts

set -eu -o pipefail

ATTR=legends-of-equestria
DOWNLOADS_PAGE="$(curl -s "$(nix-instantiate --eval -A "$ATTR.meta.downloadPage" | tr -d '"')")"
OLD_VERSION="$(nix-instantiate --eval -A "$ATTR.version" | tr -d '"')"
NIX_FILE="$(nix-instantiate --eval -A "$ATTR.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')"
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
    regex='<a href="(https[^"]+)">'"$systemText"'</a>.+v(([0-9]+\.)+[0-9]+)'

    mapfile -t matches < <(echo "$DOWNLOADS_PAGE" | grep -Fi "$systemText")
    for ((i=${#matches[@]}-1; i>=0; i--)); do
      if [[ ${matches[i]} =~ $regex ]]; then
        url="${BASH_REMATCH[1]}"
        version="${BASH_REMATCH[2]}"
        echo "$version $url" >&2
        break
      fi
    done
    if [[ -z $url || -z $version ]]; then
        echo "cannot find the latest version for $system" >&2
        exit 1
    fi
    if [[ $OLD_VERSION == $version ]]; then
        echo "already up-to-date at version $version" >&2
        exit 0
    fi

    hash="$(findHash $system "$url" | sed -E 's/sha256-(.+)/\1/')"
    echo "output hash: $hash" >&2

    oldUrl="$(nix-instantiate --system $system --eval -A $ATTR.src.url | tr -d '"')"
    oldHash="$(nix-instantiate --system $system --eval -A $ATTR.src.outputHash | tr -d '"')"
    sed -i "s|$OLD_VERSION|$version|; s|$oldUrl|$url|; s|$oldHash|$hash|" "$NIX_FILE"
}

applyUpdate x86_64-linux Linux
applyUpdate x86_64-darwin macOS
applyUpdate aarch64-darwin "macOS arm64"
