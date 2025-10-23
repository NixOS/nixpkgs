#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix-update html-xml-utils

set -ex

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

codename=`curl -L https://renpy.org/latest.html | hxclean | hxselect -c h1 small`
sed -E -i "s/(version_name = ).*/\1$codename/" $SCRIPT_DIR/package.nix

nix-update renpy
