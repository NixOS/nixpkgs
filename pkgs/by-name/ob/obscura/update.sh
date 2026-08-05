#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix yq gnugrep gnused git
set -eu -o pipefail

PACKAGE_DIR=$(dirname "$(readlink --canonicalize-existing "${BASH_SOURCE[0]}")")
OUTPUT_FILE="$PACKAGE_DIR/librusty_v8.nix"

cd "$PACKAGE_DIR"
NIXPKGS_ROOT=$(git rev-parse --show-toplevel)
cd "$NIXPKGS_ROOT"
VERSION=$(nix-instantiate --raw --eval -E "with import ./. {}; obscura.version")
CARGO_LOCK=$(curl -sL "https://raw.githubusercontent.com/h4ckf0r0day/obscura/v$VERSION/Cargo.lock")
NEW_VERSION=$(echo "$CARGO_LOCK" | tomlq -r '.package[] | select(.name == "v8") | .version')

if [ -z "$NEW_VERSION" ]; then
  echo "Could not find v8 crate in Cargo.lock" >&2
  exit 1
fi

CURRENT_VERSION=$(grep 'version =' "$OUTPUT_FILE" | sed -E 's/.*version = "([^"]+)".*/\1/')
if [ "$CURRENT_VERSION" == "$NEW_VERSION" ]; then
  echo "librusty_v8 is already at version $NEW_VERSION, nothing to do."
  exit 0
fi

TEMP_FILE=$(mktemp)
cat >"$TEMP_FILE" <<EOF
{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "$NEW_VERSION";
  hashes = {
    x86_64-linux = "$(nix-prefetch-url --type sha256 "https://github.com/denoland/rusty_v8/releases/download/v${NEW_VERSION}/librusty_v8_release_x86_64-unknown-linux-gnu.a.gz")";
    aarch64-linux = "$(nix-prefetch-url --type sha256 "https://github.com/denoland/rusty_v8/releases/download/v${NEW_VERSION}/librusty_v8_release_aarch64-unknown-linux-gnu.a.gz")";
  };
in
stdenv.mkDerivation {
  name = "librusty_v8-\${version}";

  src = fetchurl {
    url = "https://github.com/denoland/rusty_v8/releases/download/v\${version}/librusty_v8_release_\${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
    sha256 =
      hashes.\${stdenv.hostPlatform.system}
        or (throw "librusty_v8: unsupported platform \${stdenv.hostPlatform.system}");
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    gzip -cd "\$src" > "\$out"
    runHook postInstall
  '';

  meta = {
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames hashes;
  };
}
EOF

mv "$TEMP_FILE" "$OUTPUT_FILE"
echo "Updated librusty_v8 from $CURRENT_VERSION to $NEW_VERSION."
