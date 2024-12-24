#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl jq
set -euo pipefail

cd $(dirname "${BASH_SOURCE[0]}")

setKV () {
    sed -i "s|$2 = \".*\"|$2 = \"${3:-}\"|" $1
}

version=$(curl -s --show-error "https://api.github.com/repos/zadam/trilium/releases/latest" | jq -r '.tag_name' | tail -c +2)

# Update desktop application
sha256_linux64=$(nix-prefetch-url --quiet https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-${version}.tar.xz)
sha256_darwin64=$(nix-prefetch-url --quiet https://github.com/zadam/trilium/releases/download/v${version}/trilium-mac-x64-${version}.zip)
setKV ./desktop.nix version $version
setKV ./desktop.nix linuxSource.sha256 $sha256_linux64
setKV ./desktop.nix darwinSource.sha256 $sha256_darwin64

# Update server
sha256_linux64_server=$(nix-prefetch-url --quiet https://github.com/zadam/trilium/releases/download/v${version}/trilium-linux-x64-server-${version}.tar.xz)
setKV ./server.nix version $version
setKV ./server.nix serverSource.sha256 $sha256_linux64_server
