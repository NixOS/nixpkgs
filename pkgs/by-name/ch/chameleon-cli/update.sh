#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils nix-update

# This update script exists, because nix-update is unable to ignore `dev`
# tags that exist on the upstream repo.
#
# Once https://github.com/Mic92/nix-update/issues/322 is resolved it can be
# removed.

set -exuo pipefail

cd "$(git rev-parse --show-toplevel)"

nix-update --version=branch chameleon-cli

tag=$(git ls-remote --tags --refs --sort='-version:refname' https://github.com/RfidResearchGroup/ChameleonUltra.git 'v*' | head -n 1 | cut --delimiter=/ --field=3-)
tag="${tag#v}"
sed -i -e 's|version = "[^-]*-unstable-|version = "'"${tag}"'-unstable-|' pkgs/by-name/ch/chameleon-cli/package.nix
