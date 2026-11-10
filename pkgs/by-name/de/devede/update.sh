#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl nix-update xmlstarlet

set -euo pipefail

latest_tag=$(curl -s "https://gitlab.com/rastersoft/devedeng/-/tags?format=atom" | xmlstarlet sel -t -v "(//*[local-name()='entry']/*[local-name()='title'])[1]")
nix-update devede --version $latest_tag
