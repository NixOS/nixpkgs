#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pcre common-updater-scripts

set -eu -o pipefail

version="$(curl -sI https://zoom.us/client/latest/zoom_x86_64.tar.xz | grep -Fi 'Location:' | pcregrep -o1 '/(([0-9]\.?)+)/')"
update-source-version zoom-us "$version"
