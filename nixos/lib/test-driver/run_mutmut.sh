#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../.. -p black python3Packages.mutmut python3Packages.coverage -i bash

set -euxo pipefail

coverage combine --keep $(nix-build ../../.. -A nixosTests.nixos-test-driver)

mutmut run \
    --runner "nix build -f ../../.. nixosTests.nixos-test-driver" \
    --paths-to-mutate "./test_driver/machine.py" \
    --use-coverage \
    --post-mutation "black test_driver -q"
