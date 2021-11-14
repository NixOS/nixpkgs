#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash

version="$(curl -sL "https://api.github.com/repos/logseq/logseq/releases" | jq '.[0].tag_name' --raw-output)"
update-source-version logseq "$version"
