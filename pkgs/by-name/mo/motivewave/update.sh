#!/usr/bin/env nix-shell
#!nix-shell -I bash -p curl common-updater-scripts

set -euo pipefail

file="$(dirname "${BASH_SOURCE[0]}")/package.nix"

# Should return a URL in this format:
# https://downloads.motivewave.com/builds/buildNumber/motivewave_version_amd64.deb
redirected="$(
  curl -fsSLI -o /dev/null -w '%{url_effective}' "https://www.motivewave.com/update/download.do?file_type=LINUX"
)"
build_number="$(sed -nE 's#^.*/builds/([0-9]+)/.*#\1#p' <<<"$redirected")"
version="$(sed -nE 's#^.*/motivewave_([0-9.]+)_amd64\.deb#\1#p' <<<"$redirected")"

if [[ -z "$build_number" || -z "$version" ]]; then
  echo "Failed to parse URL: $redirected" >&2
  exit 1
fi

tmp="$(mktemp)"
sed -E \
  -e "s/buildNumber = \".*\";/buildNumber = \"$build_number\";/" \
  "$file" > "$tmp"
mv "$tmp" "$file"
update-source-version motivewave "$version"
