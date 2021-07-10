#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -euo pipefail

CLIENT_UPGRADE_URL="https://client-upgrade-a.wbx2.com/client-upgrade/api/v1/webexteamsdesktop/upgrade/@me?channel=gold&model=ubuntu"

curl "$CLIENT_UPGRADE_URL" | jq '.manifest | {version, packageLocation, checksum}' > version.json
