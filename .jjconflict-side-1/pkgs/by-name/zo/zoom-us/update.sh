#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq

set -eu -o pipefail

update-source-version zoom-us $(curl -Ls 'https://zoom.us/rest/download?os=linux' | jq -r .result.downloadVO.zoom.version) --source-key=unpacked.src
