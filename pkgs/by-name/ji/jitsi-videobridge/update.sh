#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup common-updater-scripts

set -eu -o pipefail

version="$(curl https://download.jitsi.org/stable/ | \
    pup 'a[href] text{}' | \
    awk -F'[_-]' '/jitsi-videobridge2/ {printf $3"-"$4"-"$5"\n"}' | \
    sort -Vu | \
    tail -n 1)"

update-source-version jitsi-videobridge "$version"
