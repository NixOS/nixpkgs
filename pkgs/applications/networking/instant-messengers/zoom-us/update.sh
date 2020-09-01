#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup common-updater-scripts

set -eu -o pipefail

version="$(curl -Ls https://zoom.us/download\?os\=linux | pup '.linux-ver-text text{}' | cut -d' ' -f2)"

update-source-version zoom-us "$version"
