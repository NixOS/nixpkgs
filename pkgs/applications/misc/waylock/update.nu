#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell common-updater-scripts

let latest_tag = list-git-tags --url=https://codeberg.org/ifreund/waylock | lines | sort --natural | str replace v '' | last
update-source-version waylock $latest_tag
