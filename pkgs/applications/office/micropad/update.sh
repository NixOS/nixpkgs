#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -i bash -p curl common-updater-scripts jq nix nodePackages.prettier prefetch-yarn-deps
=======
#!nix-shell -i bash -p curl common-updater-scripts jq nix nodePackages.prettier yarn2nix
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

set -eu -o pipefail

latest_version=$(curl -s https://api.github.com/repos/MicroPad/Micropad-Electron/releases/latest | jq --raw-output '.tag_name[1:]')
old_core_hash=$(nix-instantiate --eval --strict -A "micropad.micropad-core.drvAttrs.outputHash" | tr -d '"' | sed -re 's|[+]|\\&|g')
<<<<<<< HEAD
new_core_hash=$(nix hash to-sri --type sha256 $(nix-prefetch-url --unpack "https://github.com/MicroPad/MicroPad-Core/releases/download/v$latest_version/micropad.tar.xz"))
=======

{
    read new_core_hash
    read store_path
} < <(
    nix-prefetch-url --unpack --print-path "https://github.com/MicroPad/MicroPad-Core/releases/download/v$latest_version/micropad.tar.xz"
)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

nixFile=$(nix-instantiate --eval --strict -A "micropad.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')
nixFolder=$(dirname "$nixFile")

sed -i "$nixFile" -re "s|\"$old_core_hash\"|\"$new_core_hash\"|"

curl -o "$nixFolder/package.json" -s "https://raw.githubusercontent.com/MicroPad/MicroPad-Electron/v$latest_version/package.json"
curl -o "$nixFolder/yarn.lock" -s "https://raw.githubusercontent.com/MicroPad/MicroPad-Electron/v$latest_version/yarn.lock"

prettier --write "$nixFolder/package.json"
<<<<<<< HEAD
old_yarn_hash=$(nix-instantiate --eval --strict -A "micropad.offlineCache.outputHash" | tr -d '"' | sed -re 's|[+]|\\&|g')
new_yarn_hash=$(nix hash to-sri --type sha256 $(prefetch-yarn-deps "$nixFolder/yarn.lock"))
sed -i "$nixFile" -re "s|\"$old_yarn_hash\"|\"$new_yarn_hash\"|"
rm "$nixFolder/yarn.lock"
=======
yarn2nix --lockfile "$nixFolder/yarn.lock" >"$nixFolder/yarn.nix"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

update-source-version micropad "$latest_version"
