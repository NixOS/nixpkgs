#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

currentVersion="$(nix-instantiate --eval --raw -A session-desktop.version)"
latestVersion="$(
  curl -s https://api.github.com/repos/session-foundation/session-desktop/releases/latest \
    ${GITHUB_TOKEN:+--user ":$GITHUB_TOKEN"} \
  | jq -r .tag_name | sed 's/^v//'
)"
if [ "$currentVersion" = "$latestVersion" ]; then
  echo "Already up-to-date"
  exit 0
fi

yarnLock="$(curl -s https://raw.githubusercontent.com/session-foundation/session-desktop/v$latestVersion/yarn.lock)"
depVersion() {
  name="$(echo "$1" | sed 's/\//\\&/g')"
  echo "$yarnLock" | awk '/^"?'"$name"'@/ {flag=1; next} flag && /^  version "[^"]+"/ {match($0, /^  version "([^"]+)"/, a); print a[1]; exit}' -
}

update-source-version session-desktop.passthru.libsession-util.nodejs "$(depVersion libsession_util_nodejs)"

downloadJs="$(curl -s https://raw.githubusercontent.com/signalapp/better-sqlite3/v$(depVersion @signalapp/better-sqlite3)/deps/download.js)"
sqlDepVersion() {
  echo "$downloadJs" | awk "match(\$0, /^const ${1}_VERSION = '([0-9.]+)['-]/, a) {print a[1]}" -
}

update-source-version session-desktop.passthru.sqlcipher-src "$(sqlDepVersion SQLCIPHER)"
update-source-version session-desktop.passthru.signal-sqlcipher-extension "$(sqlDepVersion EXTENSION)"

update-source-version session-desktop "$latestVersion"
