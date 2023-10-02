#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts jq nix nodePackages.prettier prefetch-yarn-deps

set -eu -o pipefail

latest_version=$(curl -s https://api.github.com/repos/MicroPad/Micropad-Electron/releases/latest | jq --raw-output '.tag_name[1:]')
old_core_hash=$(nix-instantiate --eval --strict -A "micropad.micropad-core.drvAttrs.outputHash" | tr -d '"' | sed -re 's|[+]|\\&|g')
new_core_hash=$(nix hash to-sri --type sha256 $(nix-prefetch-url --unpack "https://github.com/MicroPad/MicroPad-Core/releases/download/v$latest_version/micropad.tar.xz"))

nixFile=$(nix-instantiate --eval --strict -A "micropad.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')
nixFolder=$(dirname "$nixFile")

sed -i "$nixFile" -re "s|\"$old_core_hash\"|\"$new_core_hash\"|"

curl -o "$nixFolder/package.json" -s "https://raw.githubusercontent.com/MicroPad/MicroPad-Electron/v$latest_version/package.json"
curl -o "$nixFolder/yarn.lock" -s "https://raw.githubusercontent.com/MicroPad/MicroPad-Electron/v$latest_version/yarn.lock"

prettier --write "$nixFolder/package.json"
old_yarn_hash=$(nix-instantiate --eval --strict -A "micropad.offlineCache.outputHash" | tr -d '"' | sed -re 's|[+]|\\&|g')
new_yarn_hash=$(nix hash to-sri --type sha256 $(prefetch-yarn-deps "$nixFolder/yarn.lock"))
sed -i "$nixFile" -re "s|\"$old_yarn_hash\"|\"$new_yarn_hash\"|"
rm "$nixFolder/yarn.lock"

update-source-version micropad "$latest_version"
