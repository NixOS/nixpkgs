#! /usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts findutils

set -euo pipefail

version="$(curl -s https://cdn.hdos.dev/client/getdown.txt | grep 'launcher.version = ' | cut -d '=' -f2 | xargs)"
update-source-version hdos "$version"
