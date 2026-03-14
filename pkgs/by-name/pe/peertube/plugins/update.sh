#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix-update
# Once  https://github.com/Mic92/nix-update/issues/281 is resolved, the usage of
# this script can be replaced with:
#
# ```nix
# passthru.updateScript = nix-update-script {
#   extraArgs = [ "--version=branch" ];
# };
# ```
#

set -euo pipefail

# Run `unstableGitUpdater`. the script and arguments for running it
# should be passed to this script.
eval $@

# Handle `npmDepsHash`
nix-update --version=skip $UPDATE_NIX_ATTR_PATH
