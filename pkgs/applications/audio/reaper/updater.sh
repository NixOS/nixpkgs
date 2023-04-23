#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

reaper_ver=$(curl -Ls https://www.reaper.fm/download.php | grep -o 'Version [0-9]\.[0-9]*' | head -n1 | cut -d' ' -f2)

function set_hash_for_arch() {
  local arch=$1
  pkg_hash=$(nix-prefetch-url https://www.reaper.fm/files/${reaper_ver%.*}.x/reaper${reaper_ver/./}_linux_$arch.tar.xz)
  pkg_hash=$(nix hash to-sri "sha256:$pkg_hash")
  # reset the version so the second architecture update doesn't get ignored
  update-source-version reaper 0 "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" --system=$arch-linux
  update-source-version reaper "${reaper_ver}" "$pkg_hash" --system=$arch-linux
}

set_hash_for_arch aarch64
set_hash_for_arch x86_64
