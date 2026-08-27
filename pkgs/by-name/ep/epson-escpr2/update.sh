#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq common-updater-scripts
set -eou pipefail

result=$(curl -sSL 'https://download-center.epson.com/api/v1/modules/?device_id=XP-970%20Series&os=DEBARM32&region=US&language=en' | jq -r '.items[] | select(.module_name == "Epson Inkjet Printer Driver 2 (ESC/P-R) for Linux" and .cti_category == "Sources")')

latestVersion=$(jq '.version' <<< "$result" | tr -d '"')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; (lib.getVersion epson-escpr2)" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

url=$(jq '.url' <<< "$result" | tr -d '"')

hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $(nix-prefetch-url $url))
update-source-version epson-escpr2 $latestVersion $hash $url --ignore-same-version
