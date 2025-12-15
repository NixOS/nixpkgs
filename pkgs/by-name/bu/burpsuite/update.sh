#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq xxd gnused diffutils
set -eu -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

curl -s 'https://portswigger.net/burp/releases/data' | jq -r '
      def verarr: (.Version // "") | split(".") | map(tonumber? // 0);
      [ .ResultSet.Results[]
        | select((.categories|sort) == (["Professional","Community"]|sort))
        | .builds[]
        | select(.ProductPlatform == "Jar")
      ] as $all
      | ($all | max_by( (.Version // "") | split(".") | map(tonumber? // 0) ) | .Version) as $v
      | $all | map(select(.Version == $v))
      ' > latest.json

version=$(jq -r '.[0].Version' latest.json)

comm_hex=$(jq -r '.[] | select(.ProductId=="community") .Sha256Checksum' latest.json)
pro_hex=$(jq -r '.[] | select(.ProductId=="pro") .Sha256Checksum' latest.json)

comm_sri="sha256-$(printf %s "$comm_hex" | xxd -r -p | base64 -w0)"
pro_sri="sha256-$(printf %s "$pro_hex" | xxd -r -p | base64 -w0)"

sed -i \
  -e "s|^\(\s*version = \)\"[^\"]*\";|\1\"$version\";|" \
  -e "/productName = \"community\"/,/hash =/ {
        s|sha256-[^\"]*|$comm_sri|
     }" \
  -e "/productName = \"pro\"/,/hash =/ {
        s|sha256-[^\"]*|$pro_sri|
     }" \
  $SCRIPT_DIR/package.nix

echo "burpsuite → $version"
echo "  community: $comm_sri"
echo "  pro      : $pro_sri"
