#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq
set -euo pipefail

cd $(dirname "${BASH_SOURCE[0]}")

setKV () {
    sed -i "s|$2 = \".*\"|$2 = \"${3:-}\"|" $1
}

version=$(curl "https://download.wavebox.app/stable/linux/latest.json" | jq --raw-output '.["urls"]["tar"] | match("https://download.wavebox.app/stable/linux/tar/Wavebox_(.+).tar.gz").captures[0]["string"]')

sha256_linux64=$(nix-prefetch-url --quiet https://download.wavebox.app/stable/linux/tar/Wavebox_${version}.tar.gz)
setKV ./default.nix version $version
setKV ./default.nix sha256 "$sha256_linux64"
