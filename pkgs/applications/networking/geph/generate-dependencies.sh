#!/usr/bin/env nix-shell
#! nix-shell -i bash -p node2nix

sed -i -e '/"electron"/d' \
  -e '/"electron-builder"/d' \
  -e '/"electron-packager"/d' \
  package.json
sed -i -e '/^    "electron": {/,/^    },/d' \
  -e '/^    "electron-builder": {/,/^    },/d' \
  -e '/^    "electron-packager": {/,/^    },/d' \
  package-lock.json

node2nix \
  --development
  --nodejs-14 \
  --node-env ../../../development/node-packages/node-env.nix \
  --input package.json \
  --lock package-lock.json \
  --output node-packages.nix \
  --composition node-composition.nix

rm -f package.json package-lock.json
