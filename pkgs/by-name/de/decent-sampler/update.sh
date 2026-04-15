#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl xmlstarlet common-updater-scripts
set -euo pipefail
page="https://store.decentsamples.com/downloads/decent-sampler/versions/xml"
latest_version="$(curl -fsSL "$page" | xmlstarlet sel -t -v '(//release)[1]/@version')"
update-source-version decent-sampler "$latest_version" --ignore-same-version --print-changes
