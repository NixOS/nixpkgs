#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix python3

set -euo pipefail

cd "$(readlink -e "$(dirname "${BASH_SOURCE[0]}")")"

# Latest client revision, from the same endpoint the official launcher uses
revision="$(curl -fsSL https://dl.pokemmo.com/live/current/revision.txt)"

# The darwin launcher version is not exposed as a number anywhere; the
# official darwin download redirects to PokeMMO-vN.dmg, so follow it
launcher_url="$(curl -fsSI https://pokemmo.com/download_file/8/ |
  sed -n 's/^[Ll]ocation: *\(.*\)\r\?$/\1/p')"
launcher_version="$(printf '%s' "$launcher_url" |
  sed -n 's|.*PokeMMO-v\([0-9][0-9]*\)\.dmg.*|\1|p')"

if [ -z "$launcher_version" ]; then
  echo "error: could not determine launcher version from $launcher_url" >&2
  exit 1
fi

package_nix="$(<package.nix)"
regex='version = "([0-9]+)";'
[[ $package_nix =~ $regex ]] && old_revision=${BASH_REMATCH[1]}
regex='launcherVersion = "([0-9]+)";'
[[ $package_nix =~ $regex ]] && old_launcher_version=${BASH_REMATCH[1]}

if [[ ${old_revision:-} == "$revision" && ${old_launcher_version:-} == "$launcher_version" ]]; then
  echo "pokemmo is already up-to-date (revision $revision, launcher version $launcher_version)"
  exit 0
fi

echo "Updating pokemmo: revision $old_revision -> $revision, launcher version $old_launcher_version -> $launcher_version"

# The server ignores the r= query parameter, so prefetch from the
# stable URL. The pinned hash covers the ?r= URL too, since the
# content is the same.
prefetch_out="$(nix-prefetch-url --print-path \
  https://dl.pokemmo.com/live/current/PokeMMO-Client.zip)"
zip_hash="$(printf '%s\n' "$prefetch_out" | sed -n 1p)"
zip_store_path="$(printf '%s\n' "$prefetch_out" | sed -n 2p)"

# The zip must contain the revision just fetched
zip_revision="$(python3 -c '
import sys, zipfile
print(zipfile.ZipFile(sys.argv[1]).read("revision.txt").decode().strip())
' "$zip_store_path")"
if [ "$zip_revision" != "$revision" ]; then
  echo "error: zip contains revision $zip_revision, expected $revision" >&2
  exit 1
fi

zip_hash="$(nix --extra-experimental-features nix-command hash convert \
  --hash-algo sha256 --to sri "$zip_hash")"

dmg_hash="$(nix-prefetch-url --quiet \
  "https://dl.pokemmo.com/PokeMMO-v${launcher_version}.dmg")"
dmg_hash="$(nix --extra-experimental-features nix-command hash convert \
  --hash-algo sha256 --to sri "$dmg_hash")"

sed -i \
  -e "s|  version = \"[0-9][0-9]*\";|  version = \"$revision\";|" \
  -e "s|  launcherVersion = \"[0-9][0-9]*\";|  launcherVersion = \"$launcher_version\";|" \
  -e '/PokeMMO-v/{n;s|hash = .*|hash = "'"$dmg_hash"'";|}' \
  -e '/PokeMMO-Client.zip/{n;s|hash = .*|hash = "'"$zip_hash"'";|}' \
  package.nix
