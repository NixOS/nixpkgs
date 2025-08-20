#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix ripgrep

set -xeu -o pipefail

PACKAGE_DIR="$(realpath "$(dirname "$0")")"

current="$(nix eval -f "$PACKAGE_DIR/sources.nix" --raw version || :)"
latest="$(curl -sS https://breitbandmessung.de/desktop-app | \
  rg '.*Aktuelle Version der Desktop-App lautet:\s*([.0-9]+).*' -r '$1')"

if [[ $current != $latest ]]; then
  linux_hash="$(nix store prefetch-file --json https://download.breitbandmessung.de/bbm/Breitbandmessung-${latest}-linux.deb | jq -r .hash)"
  darwin_hash="$(nix store prefetch-file --json https://download.breitbandmessung.de/bbm/Breitbandmessung-${latest}-mac.dmg | jq -r .hash)"

  cat <<EOF >"$PACKAGE_DIR/sources.nix"
{
  version = "${latest}";
  x86_64-linux = {
    url = "https://download.breitbandmessung.de/bbm/Breitbandmessung-${latest}-linux.deb";
    sha256 = "${linux_hash}";
  };
  x86_64-darwin = {
    url = "https://download.breitbandmessung.de/bbm/Breitbandmessung-${latest}-mac.dmg";
    sha256 = "${darwin_hash}";
  };
}
EOF
fi
