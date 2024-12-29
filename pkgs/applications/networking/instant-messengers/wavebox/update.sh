#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl jq

version=$(curl "https://download.wavebox.app/stable/linux/latest.json" | jq --raw-output '.["urls"]["tar"] | match("https://download.wavebox.app/stable/linux/tar/Wavebox_(.+).tar.gz").captures[0]["string"]')
nix-update wavebox --version "$version"
