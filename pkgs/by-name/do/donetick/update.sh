#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash curl coreutils jq git nodejs nix-prefetch-github prefetch-npm-deps nix-update nix

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
frontend_nix="$script_dir/frontend.nix"
lockfile="$script_dir/package-lock.json"

github_api() {
  curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL "https://api.github.com$1"
}

set_attr() {
  local file=$1 attr=$2 value=$3
  sed -i -E "s|^([[:space:]]*)$attr = [^;]*;.*|\1$attr = \"$value\";|" "$file"
}

current_version=$(nix-instantiate --eval -E "with import ./. {}; donetick.version" | tr -d '"')
echo "donetick: current backend version: $current_version" >&2

latest_release=$(github_api "/repos/donetick/donetick/releases/latest")
new_version=$(jq -r '.tag_name | ltrimstr("v")' <<<"$latest_release")
published_at=$(jq -r '.published_at' <<<"$latest_release")

if [[ "$new_version" == "$current_version" ]]; then
  echo "donetick: already up to date at $current_version" >&2
  exit 0
fi

echo "donetick: updating backend $current_version -> $new_version (released $published_at)" >&2

frontend_commit_json=$(github_api "/repos/donetick/frontend/commits?until=$published_at&per_page=1")
frontend_commit=$(jq -r '.[0].sha' <<<"$frontend_commit_json")
frontend_date=$(jq -r '.[0].commit.committer.date' <<<"$frontend_commit_json")

if [[ -z "$frontend_commit" || "$frontend_commit" == "null" ]]; then
  echo "donetick: could not find any donetick/frontend commit before $published_at" >&2
  exit 1
fi
frontend_day=${frontend_date%%T*}
echo "donetick: pairing with donetick/frontend@$frontend_commit ($frontend_date)" >&2

echo "donetick: prefetching frontend src hash" >&2
frontend_hash=$(nix-prefetch-github donetick frontend --rev "$frontend_commit" | jq -r .hash)

echo "donetick: regenerating package[-lock].json from a clean checkout" >&2
workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

git clone --quiet https://github.com/donetick/frontend.git "$workdir/frontend"
git -C "$workdir/frontend" checkout --quiet "$frontend_commit"
rm -f "$workdir/frontend/package-lock.json"
rm -rf "$workdir/frontend/node_modules"

# Drop dev-dependencies whose build scripts try to access the network
(cd "$workdir/frontend" && npm pkg delete devDependencies."@capacitor/assets")
(cd "$workdir/frontend" && npm pkg delete devDependencies."@vite-pwa/assets-generator")

(cd "$workdir/frontend" && npm install --package-lock-only --ignore-scripts --loglevel=error)

cp "$workdir/frontend/package-lock.json" "$lockfile"
cp "$workdir/frontend/package.json" "$script_dir/package.json"

echo "donetick: computing npmDepsHash" >&2
npm_deps_hash=$(prefetch-npm-deps "$lockfile")

set_attr "$frontend_nix" version "unstable-$frontend_day"
set_attr "$frontend_nix" rev "$frontend_commit"
set_attr "$frontend_nix" hash "$frontend_hash"
set_attr "$frontend_nix" npmDepsHash "$npm_deps_hash"

echo "donetick: running nix-update for the backend package" >&2
nix-update donetick --version "$new_version"

echo "donetick: updated to $new_version (frontend @ $frontend_commit, $frontend_day)" >&2
