#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup common-updater-scripts
# shellcheck shell=bash

set -eu -o pipefail

version="$(curl -Ls https://www.bluejeans.com/downloads | \
    pup 'a[href$=".rpm"] attr{href}' | \
    # output contains app and events
    grep "desktop-app" | \
    awk -F'[ ._ ]' '{printf $6"."$7"."$8"."$9"\n"}')"

update-source-version bluejeans-gui "$version"
