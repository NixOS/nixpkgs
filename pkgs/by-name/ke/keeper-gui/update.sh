#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq curl common-updater-scripts

set -eu -o pipefail

# Yes, I know the extension is .txt, but it's json. Take it up with keeper.
version=$(curl -s "https://download.keepersecurity.com/desktop_electron/desktop_electron_version.txt" | jq '.version' -r )
update-source-version keeper-gui "$version"
