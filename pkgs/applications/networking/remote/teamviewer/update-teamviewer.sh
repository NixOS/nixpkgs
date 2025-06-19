#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix-update curl

TEAMVIEWER_VER=$(curl -s https://www.teamviewer.com/en-us/download/linux/ | grep -oP 'Current version: <span data-dl-version-label>\K[0-9]+\.[0-9]+\.[0-9]+')

nix-update --version "$TEAMVIEWER_VER" --system x86_64-linux teamviewer
nix-update --version "skip" --system aarch64-linux teamviewer
