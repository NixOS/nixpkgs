# Tests _for the testers_

    cd nixpkgs
    nix-build -A tests.testers

Tests generally derive their own correctness from simplicity, which in the
case of testers (themselves functions) does not always work out.
Hence the need for tests that test the testers.
