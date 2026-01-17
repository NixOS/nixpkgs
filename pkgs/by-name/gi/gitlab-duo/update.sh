#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p git jaq prefetch-npm-deps nix-update npm-lockfile-fix
set -euo pipefail

# Get new Gitlab Duo release
nix-update --src-only "$UPDATE_NIX_ATTR_PATH"

# Clone new sources
dir="$(mktemp -d --suffix="$UPDATE_NIX_PNAME")"
git clone --depth 1 \
  --branch "$(nix-instantiate --eval --raw -E "with import ./. {}; $UPDATE_NIX_ATTR_PATH.src.tag")" \
  "$(nix-instantiate --eval --raw -E "with import ./. {}; $UPDATE_NIX_ATTR_PATH.src.gitRepoUrl")" \
  "$dir"
pushd "$dir"

# HACK https://github.com/npm/cli/issues/4460
# Different dependencies require different versions of esbuild. Vite's lacks
# some integrity hashes. We add a dummy "extra-deps" package to the workspace
# to force recording those hashes.
esbuild_version=$(jaq -r '.packages["node_modules/vite/node_modules/esbuild"].version' ./package-lock.json)
mkdir packages/extra-deps
cat > packages/extra-deps/package.json <<EOF
{
  "devDependencies": {
    "only-allow": "*"
  },
  "optionalDependencies": {
    "esbuild": "$esbuild_version"
  }
}
EOF
jaq -i '.devDependencies["extra-deps"]="workspace:*"' ./package.json

# HACK https://github.com/npm/cli/issues/6787
# Commander requires a higher version than the one locked, so we remove it from the lock
commander_version=$(jaq -r '.packages["packages/cli"].devDependencies.commander' ./package-lock.json)
# Remove ^ prefix
commander_version="${commander_version/^}"
# Sync locked version and remove URL and hash, so they are fixed later
jaq -i --arg ver "$commander_version" \
  '.packages["packages/cli/node_modules/commander"].version = $ver | del(.packages["packages/cli/node_modules/commander"].integrity, .packages["packages/cli/node_modules/commander"].resolved)' \
  ./package-lock.json

npm install --package-lock-only --ignore-scripts
npm-lockfile-fix package-lock.json
npmDepsHash="$(prefetch-npm-deps package-lock.json)"
git add -A
patch="$(git diff --cached)"
popd

# Update nix expression with new hashes
pushd "$(dirname "${BASH_SOURCE[0]}")"
echo "$patch" > missing-hashes.patch
sed -E 's#\bnpmDepsHash = ".*?"#npmDepsHash = "'"$npmDepsHash"'"#' -i package.nix
popd
