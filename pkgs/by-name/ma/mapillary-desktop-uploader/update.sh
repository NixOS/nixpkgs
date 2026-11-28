#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -eu -o pipefail

version="$(curl -sI https://tools.mapillary.com/uploader/download/linux | grep -Fi 'location:' | sed -n 's/.*mapillary-uploader-\([0-9.]\+\)\.AppImage.*/\1/p')"
update-source-version mapillary-desktop-uploader "$version"
