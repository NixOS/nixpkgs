#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash

version="$(curl -sL "https://api.github.com/repos/ONLYOFFICE/DesktopEditors/releases?per_page=1" | jq -r ".[0].tag_name" | sed 's/^v//')"
update-source-version onlyoffice-bin "$version"
