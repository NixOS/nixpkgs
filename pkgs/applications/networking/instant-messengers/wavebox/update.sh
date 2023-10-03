#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl gnugrep
set -euo pipefail

cd $(dirname "${BASH_SOURCE[0]}")

setKV () {
    sed -i "s|$2 = \".*\"|$2 = \"${3:-}\"|" $1
}

version=$(curl -LIs --show-error -o /dev/null -w %{url_effective} 'https://download.wavebox.app/latest/stable/linux/tar' | grep -oP 'Wavebox_\K(.+)(?=.tar.gz)')

sha256_linux64=$(nix-prefetch-url --quiet https://download.wavebox.app/stable/linux/tar/Wavebox_${version}.tar.gz)
setKV ./default.nix version $version
setKV ./default.nix sha256 "$sha256_linux64"
