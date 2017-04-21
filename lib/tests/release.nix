{ nixpkgs ? { outPath = (import ../.).cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, # The platforms for which we build Nixpkgs.
  supportedSystems ? [ builtins.currentSystem ]
, # Strip most of attributes when evaluating to spare memory usage
  scrubJobs ? true
}:

with import ../../pkgs/top-level/release-lib.nix { inherit supportedSystems scrubJobs; };
with lib;

{
  systems = import ./systems.nix { inherit lib assertTrue; };

  moduleSystem = pkgs.stdenv.mkDerivation {
    name = "nixpkgs-lib-tests";
    buildInputs = [ pkgs.nix ];
    NIX_PATH="nixpkgs=${nixpkgs}";

    buildCommand = ''
      datadir="${pkgs.nix}/share"
      export TEST_ROOT=$(pwd)/test-tmp
      export NIX_BUILD_HOOK=
      export NIX_CONF_DIR=$TEST_ROOT/etc
      export NIX_DB_DIR=$TEST_ROOT/db
      export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
      export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
      export NIX_MANIFESTS_DIR=$TEST_ROOT/var/nix/manifests
      export NIX_STATE_DIR=$TEST_ROOT/var/nix
      export NIX_STORE_DIR=$TEST_ROOT/store
      export PAGER=cat
      cacheDir=$TEST_ROOT/binary-cache
      nix-store --init

      cd ${nixpkgs}/lib/tests
      ./modules.sh

      touch $out
    '';
  };
}
