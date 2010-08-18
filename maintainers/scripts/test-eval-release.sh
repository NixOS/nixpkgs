#! /bin/sh

nix-instantiate --strict --eval-only --xml --show-trace "$(dirname "$0")"/eval-release.nix 2>&1 > /dev/null
