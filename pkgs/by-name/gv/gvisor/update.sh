#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash coreutils curl gnugrep gnused jq nix nix-update

set -euo pipefail

pkg=gvisor
repo=google/gvisor
package_file=pkgs/by-name/gv/gvisor/package.nix

curl_args=(--fail --silent --show-error --location)
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  curl_args+=(--user ":$GITHUB_TOKEN")
fi

# Releases are tagged `release-<YYYYMMDD>.<n>`.
latest_version=$(
  curl "${curl_args[@]}" "https://api.github.com/repos/$repo/releases/latest" \
    | jq -r '.tag_name | sub("^release-"; "")'
)

# The synthetic `go` branch is not tagged, so look its revision up separately.
latest_rev=$(
  curl "${curl_args[@]}" "https://api.github.com/repos/$repo/branches/go" \
    | jq -r '.commit.sha'
)

current_version=$(grep -oP '(?<=version = ")[^"]*' "$package_file")
current_rev=$(grep -oP '(?<=rev = ")[^"]*' "$package_file")

if [[ "$current_version" == "$latest_version" && "$current_rev" == "$latest_rev" ]]; then
  echo "$pkg is up to date: $current_version ($current_rev)"
  exit 0
fi

echo "Updating $pkg $current_version ($current_rev) -> $latest_version ($latest_rev)"

sed -i "s|^\([[:space:]]*version = \"\)[^\"]*\(\";\)|\1$latest_version\2|" "$package_file"
sed -i "s|^\([[:space:]]*rev = \"\)[0-9a-f]\{40\}\(\";\)|\1$latest_rev\2|" "$package_file"

# Only refresh the fixed-output hashes; version and rev were set above.
nix-update "$pkg" --version=skip
