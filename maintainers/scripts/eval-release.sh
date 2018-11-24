#! /bin/sh

if [[ -z "$VERBOSE" ]]; then
  echo "You may set VERBOSE=1 to see debug output or to any other non-empty string to make this script completely silent"
fi
unset HOME NIXPKGS_CONFIG # Force empty config
nix-instantiate --strict --eval-only --xml --show-trace "$(dirname "$0")"/eval-release.nix 2>&1 > /dev/null
