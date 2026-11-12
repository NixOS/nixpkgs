#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq nix bash coreutils nix-update yarn-berry_4.yarn-berry-fetcher

set -eou pipefail

PACKAGE_DIR=$(realpath "$(dirname "$0")")

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/jdalrymple/gitbeaker/releases/latest | jq --raw-output .tag_name)

if [[ "$UPDATE_NIX_OLD_VERSION" == "$latestTag" ]]; then
  echo "package is up-to-date: $UPDATE_NIX_OLD_VERSION"
  exit 0
fi

nix-update "$UPDATE_NIX_PNAME" --version "$latestTag" || true

HOME=$(mktemp -d)
export HOME

src=$(nix-build --no-link "$PWD" -A "$UPDATE_NIX_PNAME.src")
WORKDIR=$(mktemp -d)
cp --recursive --no-preserve=mode "$src/*" "$WORKDIR"
pushd "$WORKDIR"
yarn-berry-fetcher missing-hashes yarn.lock >"$PACKAGE_DIR/missing-hashes.json"
popd

nix-update "$UPDATE_NIX_PNAME" --version skip || true
