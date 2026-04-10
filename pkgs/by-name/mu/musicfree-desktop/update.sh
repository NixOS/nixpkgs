#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodejs nix-update jq curl patch diffutils

set -euo pipefail

old_version=$(nix-instantiate --eval -A musicfree-desktop.version | tr -d '"')
new_version=$(curl -sL ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} https://api.github.com/repos/maotoumao/MusicFreeDesktop/releases/latest | jq -r .tag_name | tr -d v)
if [ "$old_version" == "$new_version" ]; then
  echo "Already up to date" >&2
  exit
fi

patch=$(dirname $(nix-instantiate --eval -A musicfree-desktop.meta.position | tr -d '"' | cut -d : -f 1))/bump-deps.patch

export HOME=$(mktemp -d)
pushd $HOME

curl -L https://github.com/maotoumao/MusicFreeDesktop/raw/v$new_version/package.json -o package.json
curl -L https://github.com/maotoumao/MusicFreeDesktop/raw/v$new_version/package-lock.json -o package-lock.json

if patch --batch --dry-run -p1 -i $patch; then
  echo "Old patch works, no need to update" >&2
else
  mv package.json package.json.old
  jq '.dependencies.sharp |= (if . != null and . < "^0.33.4" then "^0.33.4" else . end)' package.json.old > package.json
  cp package-lock.json package-lock.json.old
  npm update sharp node-abi nan --package-lock-only
  diff -u --label a/package.json package.json.old --label b/package.json package.json > $patch || true
  diff -u --label a/package-lock.json package-lock.json.old --label b/package-lock.json package-lock.json >> $patch || true
fi

popd

nix-update musicfree-desktop --version $new_version
