#!/usr/bin/env bash
# Update ratspeak to the latest upstream release tag.
#
# Ratspeak resolves its protocol crates from sibling checkouts, so a version
# bump means updating five pins together: the app tag plus the four sibling
# revisions current at that tag's date. Requires: curl, jq, nix, sed.
set -euo pipefail
cd "$(dirname "$0")"

github_api() {
    curl -sfL -H "Accept: application/vnd.github+json" \
        ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} \
        "https://api.github.com/$1"
}

# Works both from the standalone packaging flake and from a nixpkgs checkout.
build() {
    if [ -f flake.nix ]; then
        nix build .#ratspeak
    else
        nix-build "$(git rev-parse --show-toplevel)" -A ratspeak --no-out-link
    fi
}

prefetch() {
    nix flake prefetch --json "github:ratspeak/$1/$2" | jq -r .hash
}

current=$(sed -nE 's/^ *version = "([^"]+)";$/\1/p' package.nix | head -1)
# releases/latest skips pre-releases (rc tags) on purpose.
tag=${RATSPEAK_TAG:-$(github_api repos/ratspeak/Ratspeak/releases/latest | jq -r .tag_name)}
new=${tag#v}

if [ "$new" = "$current" ] && [ -z "${RATSPEAK_TAG:-}" ]; then
    echo "ratspeak is up to date ($current)"
    exit 0
fi

tag_date=$(github_api "repos/ratspeak/Ratspeak/commits/$tag" | jq -r .commit.committer.date)
echo "updating ratspeak $current -> $new (tagged $tag_date)"

sed -i -E "s|^( *version = )\"[^\"]+\";|\1\"$new\";|" package.nix

app_hash=$(prefetch Ratspeak "$tag")
sed -i "/repo = \"Ratspeak\";/,/hash = / s|hash = \".*\";|hash = \"$app_hash\";|" package.nix

for repo in rsReticulum rsLXMF rsLXST lrgp-rs; do
    rev=$(github_api "repos/ratspeak/$repo/commits?until=$tag_date&per_page=1" | jq -r '.[0].sha')
    hash=$(prefetch "$repo" "$rev")
    echo "  $repo -> $rev"
    sed -i \
        -e "/repo = \"$repo\";/,/hash = / s|rev = \".*\";|rev = \"$rev\";|" \
        -e "/repo = \"$repo\";/,/hash = / s|hash = \".*\";|hash = \"$hash\";|" \
        package.nix
done

# Two-pass cargoHash: reset to the fake hash, read the real one from the
# vendor mismatch error, write it back. The build failure is expected here,
# so it must not trip set -e/pipefail.
fake="sha256-$(printf 'A%.0s' {1..43})="
sed -i -E "s|^( *cargoHash = )\".*\";|\1\"$fake\";|" package.nix
build_log=$(build 2>&1 || true)
cargo_hash=$(printf '%s\n' "$build_log" | sed -nE 's/^ *got: *(sha256-.*)$/\1/p' | head -1)
if [ -z "$cargo_hash" ]; then
    echo "error: could not extract cargoHash from build output" >&2
    exit 1
fi
sed -i -E "s|^( *cargoHash = )\".*\";|\1\"$cargo_hash\";|" package.nix

echo "verifying build..."
build
echo "ratspeak updated to $new"
