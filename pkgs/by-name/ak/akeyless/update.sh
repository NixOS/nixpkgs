#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq

set -euo pipefail

DIRNAME=$(dirname "$0")
readonly DIRNAME
readonly FORMULA_URL="https://raw.githubusercontent.com/akeylesslabs/homebrew-tap/main/Formula/akeyless.rb"
readonly NIX_FLAGS=(--extra-experimental-features 'nix-command')

# Fetch the Homebrew formula for the latest version number.
# The formula is used solely for version detection — it reliably tracks releases
# and is more up-to-date than the official changelog at
# https://download.akeyless.io/Akeyless_Changelog/cli.yaml, which lags by at
# least one release. Hashes are fetched directly from upstream (see below).
formula=$(curl --silent --fail "$FORMULA_URL")

# Parse version
new_version=$(printf '%s\n' "$formula" | grep -oE 'version "[0-9.]+"' | grep -oE '[0-9.]+')
echo "Latest version: $new_version"

current_version=$(grep -oE 'version = "[0-9.]+"' "$DIRNAME/package.nix" | grep -oE '[0-9.]+')
echo "Current version: $current_version"

if [[ "$current_version" == "$new_version" ]]; then
  echo "akeyless is up-to-date"
  exit 0
fi

# Fetch hashes by downloading the actual binaries.
# We do this for all platforms (not just Linux) because converting the hex hashes
# from the Homebrew formula via `nix hash convert` can produce a subtly wrong value —
# Nix and Homebrew may hash the same file differently, and the URL may have been
# re-served since the formula was pinned.
new_darwin_x86=$(nix "${NIX_FLAGS[@]}" store prefetch-file --json \
  "https://download.akeyless.io/Akeyless_Artifacts/MacOS/CLI/akeyless" | jq -r .hash)
new_darwin_arm=$(nix "${NIX_FLAGS[@]}" store prefetch-file --json \
  "https://download.akeyless.io/Akeyless_Artifacts/MacOS/CLI/akeyless-arm" | jq -r .hash)
new_linux=$(nix "${NIX_FLAGS[@]}" store prefetch-file --json \
  "https://download.akeyless.io/Akeyless_Artifacts/Linux/CLI/akeyless" | jq -r .hash)
new_completion=$(nix "${NIX_FLAGS[@]}" store prefetch-file --json \
  "https://download.akeyless.io/Akeyless_Artifacts/Linux/CLI/akeyless.bash_completion" | jq -r .hash)

echo "x86_64-darwin hash: $new_darwin_x86"
echo "aarch64-darwin hash: $new_darwin_arm"
echo "x86_64-linux  hash: $new_linux"
echo "bash_completion hash: $new_completion"

# Helper: read the hash that follows a given URL string in package.nix.
# Uses the trailing `";` to avoid partial matches (e.g. akeyless vs akeyless-arm).
get_current_hash() {
  local url_suffix="$1"
  awk -v needle="$url_suffix" \
    'index($0, needle) > 0 { found=1; next }
     found && /hash =/ { match($0, /sha256-[^"]+/); print substr($0, RSTART, RLENGTH); exit }' \
    "$DIRNAME/package.nix"
}

current_darwin_x86=$(get_current_hash 'MacOS/CLI/akeyless";')
current_darwin_arm=$(get_current_hash 'MacOS/CLI/akeyless-arm";')
current_linux=$(get_current_hash 'Linux/CLI/akeyless";')
current_completion=$(get_current_hash 'Linux/CLI/akeyless.bash_completion";')

# Update version string
sed -i "s|version = \"$current_version\";|version = \"$new_version\";|" "$DIRNAME/package.nix"

# Replace hashes (only when the current hash is non-empty)
[[ -n "$current_darwin_x86" ]] && sed -i "s|$current_darwin_x86|$new_darwin_x86|"   "$DIRNAME/package.nix"
[[ -n "$current_darwin_arm" ]] && sed -i "s|$current_darwin_arm|$new_darwin_arm|"   "$DIRNAME/package.nix"
[[ -n "$current_linux"      ]] && sed -i "s|$current_linux|$new_linux|"             "$DIRNAME/package.nix"
[[ -n "$current_completion" ]] && sed -i "s|$current_completion|$new_completion|"   "$DIRNAME/package.nix"

echo "Done. Updated $DIRNAME/package.nix to $new_version"
