#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

reaper_ver=$(curl -Ls https://www.reaper.fm/download.php | grep -o 'Version [0-9]\.[0-9]*' | head -n1 | cut -d' ' -f2)

function set_hash_for_linux() {
  local arch=$1
  pkg_hash=$(nix-prefetch-url https://www.reaper.fm/files/${reaper_ver%.*}.x/reaper${reaper_ver/./}_linux_$arch.tar.xz)
  pkg_hash=$(nix --extra-experimental-features nix-command hash convert "sha256:$pkg_hash")
  update-source-version reaper "${reaper_ver}" "$pkg_hash" --system=$arch-linux --ignore-same-version
}

function set_hash_for_darwin() {
  local arch=$1
  pkg_hash=$(nix-prefetch-url https://www.reaper.fm/files/${reaper_ver%.*}.x/reaper${reaper_ver/./}_universal.dmg)
  pkg_hash=$(nix --extra-experimental-features nix-command hash convert "sha256:$pkg_hash")
  update-source-version reaper "${reaper_ver}" "$pkg_hash" --system=$arch-darwin --ignore-same-version
}

set_hash_for_linux aarch64
set_hash_for_linux x86_64
set_hash_for_darwin aarch64
