#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

version="$(curl -sL "https://api.github.com/repos/ONLYOFFICE/DesktopEditors/releases?per_page=1" | jq -r ".[0].tag_name" | sed 's/^v//')"
update-source-version onlyoffice-desktopeditors "$version" --source-key=sources.x86_64-linux.hash --system=x86_64-linux
update-source-version onlyoffice-desktopeditors "$version" --source-key=sources.aarch64-linux.hash --system=aarch64-linux --ignore-same-version
