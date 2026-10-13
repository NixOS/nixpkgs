#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts

set -euo pipefail

version=$(curl -s $2 | sed -n 's#.*<span data-bind="text: current().version">\(.*\)</span>.*#\1#p')
update-source-version $1 "$version"
