#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts

RESPONSE="$(curl https://clientsettingscdn.roblox.com/v1/client-version/MacPlayer)"
VERSION="$(echo "$RESPONSE" | jq -r '.version')"
CLIENT_UPLOAD="$(echo "$RESPONSE" | jq -r '.clientVersionUpload' | sed 's/version-//')"

update-source-version roblox "$VERSION" "sha256:$src.sha256" "https://setup.rbxcdn.com/mac/arm64/version-$CLIENT_UPLOAD-RobloxPlayer.zip"
