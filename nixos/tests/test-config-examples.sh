#!/bin/sh

# This script try to evaluate all configurations which are stored in
# doc/config-examples.  This script is useful to ensure that examples are
# working with the current system.

pwd=$(pwd)
set -xe
for i in ../doc/config-examples/*.nix; do
  NIXOS_CONFIG="$pwd/$i" nix-instantiate \
      --eval-only --xml --strict > /dev/null 2>&1 \
      ../default.nix -A system
done
set +xe
