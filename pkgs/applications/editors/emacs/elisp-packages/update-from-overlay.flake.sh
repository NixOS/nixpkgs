#!/usr/bin/env nix
#! nix shell nixpkgs#bash nixpkgs#curl nixpkgs#nix nixpkgs#coreutils --command bash
set -xeuo pipefail

# Since flakes are not stable yet, we can't suppose everyone is using them.
# Therefore, the original ./update-from-overlay should not be modified.
# So, let's create a wrapper!

source ./update-from-overlay
