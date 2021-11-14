#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused common-updater-scripts
# shellcheck shell=bash

version="$(curl -sL https://onepassword.s3.amazonaws.com/linux/debian/dists/edge/main/binary-amd64/Packages | sed -r -n 's/^Version: (.*)/\1/p' | head -n1)"
update-source-version _1password-gui "$version"
