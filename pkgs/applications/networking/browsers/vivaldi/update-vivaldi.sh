#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -eu -o pipefail

version=$(curl -sS https://vivaldi.com/download/ | sed -rne 's/.*vivaldi-stable_([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)-1_amd64\.deb.*/\1/p')

update_hash() {
    url="https://downloads.vivaldi.com/stable/vivaldi-stable_$version-1_$2.deb"
    hash=$(nix hash to-sri --type sha256 $(nix-prefetch-url --type sha256 "$url"))
    update-source-version vivaldi 0 sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB= --system=$1
    update-source-version vivaldi "$version" "$hash" --system=$1
}

update_hash aarch64-linux arm64
update_hash x86_64-linux amd64
