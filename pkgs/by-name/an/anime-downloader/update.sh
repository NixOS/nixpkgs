#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -eu -o pipefail

version="$(curl --silent "https://api.github.com/repos/anime-dl/anime-downloader/releases" | jq '.[0].tag_name' --raw-output)"

update-source-version anime-downloader "$version"
