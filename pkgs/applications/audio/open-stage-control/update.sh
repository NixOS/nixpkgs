#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts jq nodePackages.node2nix
set -euo pipefail

# Find nixpkgs repo
nixpkgs="$(git rev-parse --show-toplevel || (printf 'Could not find root of nixpkgs repo\nAre we running from within the nixpkgs git repo?\n' >&2; exit 1))"

# Get latest release tag
tag="$(curl -s https://api.github.com/repos/jean-emmanuel/open-stage-control/releases/latest | jq -r .tag_name)"

# Download package.json from the latest release
curl -sSL https://raw.githubusercontent.com/jean-emmanuel/open-stage-control/"$tag"/package.json | grep -v '"electron"\|"electron-installer-debian"' >"$nixpkgs"/pkgs/applications/audio/open-stage-control/package.json

# Lock dependencies with node2nix
node2nix \
  --node-env "$nixpkgs"/pkgs/development/node-packages/node-env.nix \
  --nodejs-16 \
  --input "$nixpkgs"/pkgs/applications/audio/open-stage-control/package.json \
  --output "$nixpkgs"/pkgs/applications/audio/open-stage-control/node-packages.nix \
  --composition "$nixpkgs"/pkgs/applications/audio/open-stage-control/node-composition.nix

rm -f "$nixpkgs"/pkgs/applications/audio/open-stage-control/package.json

# Update hash
(cd "$nixpkgs" && update-source-version "${UPDATE_NIX_ATTR_PATH:-open-stage-control}" "${tag#v}")
