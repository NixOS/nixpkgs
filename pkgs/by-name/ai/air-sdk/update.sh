#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

version="$(curl -sL https://api.airsdk.harman.com/releases/latest/urls | jq -r .AIR_Linux | grep -oE '([0-9]+\.)+[0-9]+')"
update-source-version air-sdk "$version"
