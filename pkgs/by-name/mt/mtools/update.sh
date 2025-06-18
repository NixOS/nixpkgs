#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts
set -eu -o pipefail

version="$(curl -s --list-only ftp://ftp.gnu.org/gnu/mtools/ | sed 's/^.*-\([0-9]\+\.[0-9]\+\.[0-9]\+\).*$/\1/' | sort -n | uniq | tail -n1)"
update-source-version mtools "$version"
