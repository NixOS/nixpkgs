#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash curl jq common-updater-scripts git nix

set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
attr="${UPDATE_NIX_ATTR_PATH:-ninjabrain-bot}"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

latest_version=$(curl -sL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
  "https://api.github.com/repos/Ninjabrain1/Ninjabrain-Bot/releases/latest" \
  | jq -r .tag_name)
latest_version="${latest_version#v}"

current_version=$(nix eval --raw -f "$nixpkgs" "${attr}.version")
if [[ "$current_version" == "$latest_version" ]]; then
  echo "ninjabrain-bot is up-to-date: ${current_version}"
  exit 0
fi

update-source-version "$attr" "$latest_version"

pkgfile="$script_dir/package.nix"

escape_sed_pattern() {
  printf '%s' "$1" | sed -e 's/[.[\*^$()+?{}|\\]/\\&/g' -e 's#/#\\/#g'
}

escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[&/\\]/\\&/g'
}

mvn_hash_old=$(nix eval --raw -f "$nixpkgs" "${attr}.mvnHash")
fake_hash=$(nix eval --raw -f "$nixpkgs" lib.fakeHash)

mvn_hash_old_pat=$(escape_sed_pattern "$mvn_hash_old")
fake_hash_repl=$(escape_sed_replacement "$fake_hash")
sed -i "s|${mvn_hash_old_pat}|${fake_hash_repl}|" "$pkgfile"

set +e
mvn_hash_new=$(nix build --no-link -f "$nixpkgs" "$attr" 2>&1 \
  | grep -m1 'got:' \
  | cut -d: -f2- \
  | xargs echo)
set -e

if [[ -z "$mvn_hash_new" ]]; then
  echo "Failed to compute mvnHash. Check the build output above."
  exit 1
fi

fake_hash_pat=$(escape_sed_pattern "$fake_hash")
mvn_hash_new_repl=$(escape_sed_replacement "$mvn_hash_new")
sed -i "s|${fake_hash_pat}|${mvn_hash_new_repl}|" "$pkgfile"
