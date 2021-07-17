#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -euo pipefail

CLIENT_UPGRADE_URL="https://client-upgrade-a.wbx2.com/client-upgrade/api/v1/webexteamsdesktop/upgrade/@me?r=AC805C72-1377-4FE6-B272-1FB4417B50B7&channel=blue&model=ubuntu"

curl "$CLIENT_UPGRADE_URL" | jq '.manifest | {version, packageLocation, checksum}' > version.json
