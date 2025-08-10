#!/usr/bin/env nix-shell
#!nix-shell -i bash -p haskell.packages.ghc910.cabal2nix nix-prefetch-git curl jq

set -euo pipefail

# This is the directory of this update.sh script.
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
derivation_file="${script_dir}/generated-package.nix"
latest_version="$(curl --silent https://api.github.com/repos/pdobsan/oama/releases/latest | jq --raw-output '.tag_name')"

echo "Updating oama to version ${latest_version}."
echo "Running cabal2nix and outputting to ${derivation_file}..."

cat > "${derivation_file}" << EOF
# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
EOF

cabal2nix --revision "${latest_version}" https://github.com/pdobsan/oama.git >> "${derivation_file}"
nixfmt "${derivation_file}"

echo "Finished."
