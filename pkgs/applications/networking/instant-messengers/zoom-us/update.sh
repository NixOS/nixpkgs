#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup common-updater-scripts

set -eu -o pipefail

version="$(curl -Ls https://zoom.us/download\?os\=linux | \
  pup '.linux-ver-text text{}' | \
  awk -F'[ ().]' '{printf $2"."$3"."$4"."$6"\n"}')"

update-source-version zoom-us "$version"
