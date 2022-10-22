#!/usr/bin/env nix-shell
#! nix-shell -i bash -p jq nodePackages.node2nix

# Get latest release tag
tag="$(curl -s https://api.github.com/repos/jean-emmanuel/open-stage-control/releases/latest | jq -r .tag_name)"

# Download package.json from the latest release
curl -s https://raw.githubusercontent.com/jean-emmanuel/open-stage-control/"$tag"/package.json | grep -v '"electron"\|"electron-installer-debian"\|"electron-packager"\|"electron-packager-plugin-non-proprietary-codecs-ffmpeg"' >package.json

# Lock dependencies with node2nix
node2nix \
  --node-env ../../../development/node-packages/node-env.nix \
  --nodejs-16 \
  --input package.json \
  --output node-packages.nix \
  --composition node-composition.nix

rm -f package.json
