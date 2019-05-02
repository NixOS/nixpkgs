#! /bin/sh

if [[ -z "$VERBOSE" ]]; then
  echo "You may set VERBOSE=1 to see debug output or to any other non-empty string to make this script completely silent"
fi
unset HOME NIXPKGS_CONFIG # Force empty config

# With the default heap size (380MB), nix-instantiate fails:
# Too many heap sections: Increase MAXHINCR or MAX_HEAP_SECTS
export GC_INITIAL_HEAP_SIZE=${GC_INITIAL_HEAP_SIZE:-2000000000} # 2GB
nix-instantiate --strict --eval-only --xml --show-trace "$(dirname "$0")"/eval-release.nix 2>&1 > /dev/null
