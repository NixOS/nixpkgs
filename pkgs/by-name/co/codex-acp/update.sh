#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl yq

set -euo pipefail

# Update codex-acp
old_version="$(nix-instantiate --raw --eval -A codex-acp.version)"
nix-update codex-acp
new_version="$(nix-instantiate --raw --eval -A codex-acp.version)"

if [ "$old_version" = "$new_version" ]; then
  echo "No codex-acp update, nothing to do"
  exit 0
fi

PACKAGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_NIX="$PACKAGE_DIR/package.nix"

# Fetch Cargo.lock for the new version
cargo_lock="$(curl -sL "https://raw.githubusercontent.com/zed-industries/codex-acp/refs/tags/v$new_version/Cargo.lock")"

# Extract v8 version from Cargo.lock
new_v8_version="$(echo "$cargo_lock" | tomlq -r '.package[] | select(.name == "v8") | .version')"

echo "Updating librusty_v8 to $new_v8_version"

# Update librusty_v8 via nix-update on the passthru
nix-update codex-acp.librusty_v8 "--version=$new_v8_version" --override-filename pkgs/by-name/co/codex-acp/package.nix

# Extract pinned openai/codex source from Cargo.lock (first match)
codex_source="$(echo "$cargo_lock" | tomlq -r 'limit(1; .package[] | select(.source // "" | contains("github.com/openai/codex")) | .source)')"
if [[ -z "$codex_source" ]]; then
  echo "Could not find pinned openai/codex dependency in Cargo.lock" >&2
  exit 1
fi
codex_tag="$(echo "$codex_source" | sed -nE 's/.*\?tag=([^#]+).*/\1/p')"
codex_rev="$(echo "$codex_source" | sed -nE 's/.*#([0-9a-f]+)$/\1/p')"
if [[ -z "$codex_tag" || -z "$codex_rev" ]]; then
  echo "Could not parse pinned openai/codex dependency from Cargo.lock" >&2
  exit 1
fi

echo "pinned codex tag: $codex_tag"
echo "pinned codex rev: $codex_rev"

# Prefetch codex source hash
codex_hash="$(nix-prefetch-url --type sha256 --unpack "https://github.com/openai/codex/archive/${codex_rev}.tar.gz")"
codex_hash="$(nix hash to-sri --type sha256 "$codex_hash")"

# Update codexRev, codexHash, and the comment in package.nix
tmp="$(mktemp)"
awk \
  -v codex_rev="$codex_rev" \
  -v codex_hash="$codex_hash" \
  -v codex_tag="$codex_tag" \
  -v new_version="$new_version" '
  BEGIN {
    comment_count = 0
    rev_count = 0
    hash_count = 0
  }
  /codexRev = "[0-9a-f]+";/ {
    rev_count++
    sub(/codexRev = "[0-9a-f]+";/, "codexRev = \"" codex_rev "\";")
  }
  /codexHash = "sha256-[^"]+";/ {
    hash_count++
    sub(/codexHash = "sha256-[^"]+";/, "codexHash = \"" codex_hash "\";")
  }
  /# codex-acp [^ ]+ pins openai\/codex/ {
    comment_count++
    sub(/# codex-acp [^ ]+ pins openai\/codex [^ ]+ in Cargo\.lock\./, "# codex-acp " new_version " pins openai/codex " codex_tag " in Cargo.lock.")
  }
  { print }
  END {
    if (comment_count != 1) {
      print "Failed to update codex pin comment in package.nix" > "/dev/stderr"
      exit 1
    }
    if (rev_count != 1) {
      print "Failed to update codexRev in package.nix" > "/dev/stderr"
      exit 1
    }
    if (hash_count != 1) {
      print "Failed to update codexHash in package.nix" > "/dev/stderr"
      exit 1
    }
  }
' "$PACKAGE_NIX" > "$tmp"
mv "$tmp" "$PACKAGE_NIX"

echo "Updated codex-acp to $new_version with rusty-v8 $new_v8_version (codex $codex_tag)"
