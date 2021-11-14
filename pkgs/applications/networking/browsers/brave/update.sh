#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts
# shellcheck shell=bash

version="$(curl -sL https://brave-browser-apt-release.s3.brave.com/dists/stable/main/binary-amd64/Packages | sed -r -n 's/^Version: (.*)/\1/p' | head -n1)"
update-source-version brave "$version"
