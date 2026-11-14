#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix nix-update nurl gnused gnugrep

set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
cd "$nixpkgs"

pkg=pkgs/by-name/nu/nuvio-engine/package.nix

nix-update nuvio-engine

# update libtorrent-src pin
src="$(nix-build --no-out-link -A nuvio-engine.src)"
deps="$src/cmake/Dependencies.cmake"
newRev="$(grep -oP '^\s*GIT_TAG\s+\K[0-9a-f]{40}' "$deps")"
oldRev="$(nix-instantiate --eval --raw -A nuvio-engine.libtorrent-src.rev)"
if [[ "$newRev" != "$oldRev" ]]; then
  oldHash="$(nix-instantiate --eval --raw -A nuvio-engine.libtorrent-src.outputHash)"
  newHash="$(nurl --hash --submodules https://github.com/arvidn/libtorrent "$newRev")"
  sed -i -e "s|$oldRev|$newRev|" -e "s|$oldHash|$newHash|" "$pkg"
fi

# update boost pin
boostVersion="$(grep -oP 'boost\.io/release/\K[0-9]+\.[0-9]+' "$deps")"
sed -i -E "s/\bboost[0-9]+\b/boost${boostVersion//./}/g" "$pkg"
