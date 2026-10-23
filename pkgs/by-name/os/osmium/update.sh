#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl yq common-updater-scripts

version="$(curl -s https://updater.osmium.chat/alpha-linux.yml | yq -r .version)"
update-source-version osmium "$version"
