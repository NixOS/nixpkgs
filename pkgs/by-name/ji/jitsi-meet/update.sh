#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup nix-update

set -eu -o pipefail

version="$(curl https://download.jitsi.org/jitsi-meet/src/ |
  pup 'a[href] text{}' |
  awk -F'-|.tar.bz2' '/jitsi-meet-/ {printf $3"\n"}' |
  sort -Vu |
  tail -n 1)"

nix-update --version="$version" jitsi-meet
