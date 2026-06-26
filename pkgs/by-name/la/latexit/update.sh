#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts
# shellcheck shell=bash

version="$(
    curl -s "https://pierre.chachatelier.fr/latexit/downloads/latexit-sparkle-en.rss" | # Fetch the release RSS feed
        sed -nr 's/<title>Version (.*)<\/title>/\1/p' |                                 # Extract the version numbers
        tail -1 |                                                                       # Select the last one
        xargs                                                                           # Trim the extra spaces
)"
update-source-version latexit "$version"
