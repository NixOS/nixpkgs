#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pcre common-updater-scripts

set -eu -o pipefail

oldVersion=$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion zoom-us" | tr -d '"')
version="$(curl -sI https://zoom.us/client/latest/zoom_x86_64.tar.xz | grep -Fi 'Location:' | pcregrep -o1 '/(([0-9]\.?)+)/')"

if [ ! "${oldVersion}" = "${version}" ]; then
  update-source-version zoom-us "$version"
  nixpkgs="$(git rev-parse --show-toplevel)"
  default_nix="$nixpkgs/pkgs/applications/networking/instant-messengers/zoom-us/default.nix"
  git add "${default_nix}"
  git commit -m "zoom-us: ${oldVersion} -> ${version}"
else
  echo "zoom-us is already up-to-date"
fi
