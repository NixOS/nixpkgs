#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

latestTag=$(curl https://api.github.com/repos/Plutoberth/SonyHeadphonesClient/tags | jq -r '.[] | .name' | sort --version-sort | tail -1)
version="$(expr $latestTag : 'v\(.*\)')"

update-source-version sony-headphones-client "$version"
