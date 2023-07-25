#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts jq nix nodePackages.prettier yarn2nix

set -eu -o pipefail

latest_version=$(curl -s https://api.github.com/repos/MicroPad/Micropad-Electron/releases/latest | jq --raw-output '.tag_name[1:]')
old_core_hash=$(nix-instantiate --eval --strict -A "micropad.micropad-core.drvAttrs.outputHash" | tr -d '"' | sed -re 's|[+]|\\&|g')

{
    read new_core_hash
    read store_path
} < <(
    nix-prefetch-url --unpack --print-path "https://github.com/MicroPad/MicroPad-Core/releases/download/v$latest_version/micropad.tar.xz"
)

nixFile=$(nix-instantiate --eval --strict -A "micropad.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')
nixFolder=$(dirname "$nixFile")

sed -i "$nixFile" -re "s|\"$old_core_hash\"|\"$new_core_hash\"|"

curl -o "$nixFolder/package.json" -s "https://raw.githubusercontent.com/MicroPad/MicroPad-Electron/v$latest_version/package.json"
curl -o "$nixFolder/yarn.lock" -s "https://raw.githubusercontent.com/MicroPad/MicroPad-Electron/v$latest_version/yarn.lock"

prettier --write "$nixFolder/package.json"
yarn2nix --lockfile "$nixFolder/yarn.lock" >"$nixFolder/yarn.nix"

update-source-version micropad "$latest_version"
