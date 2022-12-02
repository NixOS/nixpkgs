#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq
set -euo pipefail

cd $(dirname "${BASH_SOURCE[0]}")

version=$(curl -s --show-error "https://api.github.com/repos/zadam/trilium/releases/latest" | jq -r '.tag_name' | tail -c +2)

sha256_linux64=$(nix-prefetch-url --quiet https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-${version}.tar.xz)
sha256_linux64_server=$(nix-prefetch-url --quiet https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-server-${version}.tar.xz)

setKV () {
    sed -i "s|$1 = \".*\"|$1 = \"${2:-}\"|" ./default.nix
}

setKV version $version
setKV desktopSource.sha256 $sha256_linux64
setKV serverSource.sha256 $sha256_linux64_server
