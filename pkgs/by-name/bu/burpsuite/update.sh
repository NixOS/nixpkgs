#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq xxd gnused diffutils
set -eu -o pipefail
trap 'rm -f latest.json' EXIT

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

curl -s 'https://portswigger.net/burp/releases/data' | jq -r '
      def verarr: (.Version // "") | split(".") | map(tonumber? // 0);
      [ .ResultSet.Results[]
        | select(.categories == ["Desktop"])
        | .builds[]
        | select(.BuildCategoryPlatform == "Jar")
      ] as $all
      | ($all | max_by( (.Version // "") | split(".") | map(tonumber? // 0) ) | .Version) as $v
      | $all | map(select(.Version == $v))
      ' > latest.json

version=$(jq -r '.[0].Version' latest.json)
hex=$(jq -r '.[0].Sha256Checksum' latest.json)
sri="sha256-$(printf %s "$hex" | xxd -r -p | base64 -w0)"

sed -i \
    -e "s|^\(\s*version = \)\"[^\"]*\";|\1\"$version\";|" \
    -e "s|^\(\s*hash = \)\"[^\]*\";|\1\"$sri\";|" \
    $SCRIPT_DIR/package.nix

echo "burpsuite → $version"
echo "     hash: $sri"
