#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused common-updater-scripts

set -eou pipefail

LATEST_VERSION="$(curl --silent --fail ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/PCSX2/pcsx2/releases" | jq '.[0].tag_name' --raw-output | sed 's/^v//')"

update-source-version pcsx2-bin "$LATEST_VERSION"
