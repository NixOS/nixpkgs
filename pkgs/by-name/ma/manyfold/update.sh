#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update bundix bundler nixfmt-rfc-style yarn-berry_3.yarn-berry-fetcher nix-prefetch-git ruby_3_4

set -eux

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
UPDATE_NIX_ATTR_PATH="${UPDATE_NIX_ATTR_PATH:-manyfold}"
HOME=$(mktemp -d)

# Update version and source
nix-update "$UPDATE_NIX_ATTR_PATH" --src-only || true

src=$(nix-build --no-link -A "$UPDATE_NIX_ATTR_PATH".src)

pushd "$HOME"
# Update yarn deps
yarn-berry-fetcher missing-hashes "$src/yarn.lock" >"$SCRIPT_DIR/missing-hashes.json"

# Update ruby deps
cp --recursive --no-preserve=mode "$src"/. .
BUNDLE_FORCE_RUBY_PLATFORM=true bundle lock
bundix
nixfmt gemset.nix
install -D ./{Gemfile,Gemfile.lock,gemset.nix} -t "$SCRIPT_DIR"
popd

# Update dependency hashes
nix-update "$UPDATE_NIX_ATTR_PATH" --version skip || true
