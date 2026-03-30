#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup common-updater-scripts

set -eu -o pipefail

version=$(
    curl -s http://www.necessegame.com/server \
        | pup 'a[href*="linux64"] text{}' \
        | awk -F'[v ]' '/Linux64/ {print $4"-"$6}' \
        | sort -Vu \
        | tail -n1
)

[[ $version =~ ^[0-9]+\.[0-9]+\.[0-9]+\-[0-9]+$ ]] \
    && update-source-version necesse-server "$version"
