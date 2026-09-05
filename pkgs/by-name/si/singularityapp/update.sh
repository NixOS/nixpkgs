#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts curl jq

# SingularityApp only ships a snap for Linux. This queries the snapcraft API
# for the latest version, revision and hash, then updates package.nix.
#
# The snap CDN keys downloads by an opaque `revision` (which forms the download
# URL), whereas `version` is only for human consumption, so we update both.
#
# An optional argument selects the snapcraft channel (default `stable`); only
# stable updates should be pushed to nixpkgs.

set -eu -o pipefail

channel="${1:-stable}"

data=$(curl -fsS -H 'X-Ubuntu-Series: 16' \
  "https://api.snapcraft.io/api/v1/snaps/details/singularityapp?channel=$channel&fields=download_sha512,revision,version")

version=$(jq -r .version <<<"$data")
revision=$(jq -r .revision <<<"$data")
hash=$(nix-hash --to-sri --type sha512 "$(jq -r .download_sha512 <<<"$data")")

attr="${UPDATE_NIX_ATTR_PATH:-singularityapp}"

update-source-version "$attr" "$version" "$hash"
update-source-version --ignore-same-hash --version-key=revision \
  "$attr" "$revision" "$hash"
