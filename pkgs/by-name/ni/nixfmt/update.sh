#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cabal2nix curl jq
#
# This script will update the nixfmt derivation to the latest version using
# cabal2nix.

set -eo pipefail

# This is the directory of this update.sh script.
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
derivation_file="${script_dir}/generated-package.nix"

release_tag=$(curl --silent https://api.github.com/repos/NixOS/nixfmt/releases/latest | jq '.tag_name' --raw-output)

echo "Updating nixfmt to version $release_tag."
echo "Running cabal2nix and outputting to ${derivation_file}..."

cat > "$derivation_file" << EOF
# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
EOF

cabal2nix --jailbreak \
  "https://github.com/nixos/nixfmt/archive/${release_tag}.tar.gz" \
  >> "$derivation_file"

echo "Finished."
