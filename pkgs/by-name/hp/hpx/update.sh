#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts nix nix-update

set -euo pipefail

nix-update hpx

src="$(nix-build --no-out-link -A hpx.src)"
rev="$(awk '
  /HPX_WITH_STDEXEC_TAG STRING/ { found = 1; next }
  found && match($0, /[0-9a-f]{40}/) { print substr($0, RSTART, RLENGTH); exit }
' "$src/CMakeLists.txt")"

if [[ "$(nix-instantiate --eval --raw -A hpx.stdexec.rev)" != "$rev" ]]; then
  update-source-version hpx --ignore-same-version --source-key=stdexec --rev="$rev"
fi
