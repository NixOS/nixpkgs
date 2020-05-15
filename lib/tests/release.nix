{ # The pkgs used for dependencies for the testing itself
  # Don't test properties of pkgs.lib, but rather the lib in the parent directory
  pkgs ? import ../.. {} // { lib = throw "pkgs.lib accessed, but the lib tests should use nixpkgs' lib path directly!"; }
}:

pkgs.runCommandNoCC "nixpkgs-lib-tests" {
  buildInputs = [
    pkgs.nix
    (import ./check-eval.nix)
    (import ./maintainers.nix {
      inherit pkgs;
      lib = import ../.;
    })
  ];
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
