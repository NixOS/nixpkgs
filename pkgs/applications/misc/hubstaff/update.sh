#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-git curl

SCRIPT_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")

installation_script_url=$(curl --fail --head --location --silent --output /dev/null --write-out %{url_effective} https://app.hubstaff.com/download/linux)

version=$(echo "$installation_script_url" | sed -r 's/^https:\/\/hubstaff\-production\.s3\.amazonaws\.com\/downloads\/HubstaffClient\/Builds\/Release\/([^\/]+)\/Hubstaff.+$/\1/')

sha256=$(nix-prefetch-url "$installation_script_url")

cat <<EOT > $SCRIPT_DIR/revision.json
{
  "url": "$installation_script_url",
  "version": "$version",
  "sha256": "$sha256"
}
EOT
