#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cabal2nix curl jq
#
# This script will update the nixfmt-rfc-style derivation to the latest version using
# cabal2nix.

set -eo pipefail

# This is the directory of this update.sh script.
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

derivation_file="${script_dir}/generated-package.nix"
date_file="${script_dir}/date.txt"

# This is the latest version of nixfmt-rfc-style branch on GitHub.
new_version=$(curl --silent https://api.github.com/repos/nixos/nixfmt/git/refs/heads/master | jq '.object.sha' --raw-output)
new_date=$(curl --silent https://api.github.com/repos/nixos/nixfmt/git/commits/"$new_version" | jq '.committer.date' --raw-output)

echo "Updating nixfmt-rfc-style to version $new_date."
echo "Running cabal2nix and outputting to ${derivation_file}..."

cat > "$derivation_file" << EOF
# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
EOF

cabal2nix --jailbreak \
  "https://github.com/nixos/nixfmt/archive/${new_version}.tar.gz" \
  >> "$derivation_file"

date --date="$new_date" -I > "$date_file"

echo "Finished."
