{ pkgs ? import ../.. {} }:

pkgs.runCommandNoCC "nixpkgs-lib-tests" {
  buildInputs = [ pkgs.nix (import ./check-eval.nix) ];
  NIX_PATH = "nixpkgs=${toString pkgs.path}";
} ''
    datadir="${pkgs.nix}/share"
    export TEST_ROOT=$(pwd)/test-tmp
    export NIX_BUILD_HOOK=
    export NIX_CONF_DIR=$TEST_ROOT/etc
    export NIX_DB_DIR=$TEST_ROOT/db
    export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
    export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
    export NIX_STATE_DIR=$TEST_ROOT/var/nix
    export NIX_STORE_DIR=$TEST_ROOT/store
    export PAGER=cat
    cacheDir=$TEST_ROOT/binary-cache
    nix-store --init

    cp -r ${../.} lib
    bash lib/tests/modules.sh

    touch $out
''
