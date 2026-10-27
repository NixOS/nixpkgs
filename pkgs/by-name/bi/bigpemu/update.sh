#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup common-updater-scripts
set -eu -o pipefail
page="https://www.richwhitehouse.com/jaguar/index.php?content=download"
extractor='font:contains("Current Version") strong text{}'
latest_version="$(curl "$page" | pup "$extractor")"
update-source-version \
    --ignore-same-version \
    bigpemu.unwrapped "$latest_version"
