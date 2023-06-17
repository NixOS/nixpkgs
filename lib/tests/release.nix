{ # The pkgs used for dependencies for the testing itself
  # Don't test properties of pkgs.lib, but rather the lib in the parent directory
  pkgs ? import ../.. {} // { lib = throw "pkgs.lib accessed, but the lib tests should use nixpkgs' lib path directly!"; },
  nix ? pkgs.nix,
  nixVersions ? [ pkgs.nixVersions.minimum nix pkgs.nixVersions.unstable ],
}:

let
  testWithNix = nix:
    pkgs.runCommand "nixpkgs-lib-tests-nix-${nix.version}" {
      buildInputs = [
        (import ./check-eval.nix)
        (import ./maintainers.nix {
          inherit pkgs;
          lib = import ../.;
        })
        (import ./teams.nix {
          inherit pkgs;
          lib = import ../.;
        })
        (import ../path/tests {
          inherit pkgs;
        })
      ];
      nativeBuildInputs = [
        nix
      ];
      strictDeps = true;
    } ''
      datadir="${nix}/share"
      export TEST_ROOT=$(pwd)/test-tmp
      export NIX_BUILD_HOOK=
      export NIX_CONF_DIR=$TEST_ROOT/etc
      export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
      export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
      export NIX_STATE_DIR=$TEST_ROOT/var/nix
      export NIX_STORE_DIR=$TEST_ROOT/store
      export PAGER=cat
      cacheDir=$TEST_ROOT/binary-cache

      mkdir -p $NIX_CONF_DIR
      echo "experimental-features = nix-command" >> $NIX_CONF_DIR/nix.conf

      nix-store --init

      cp -r ${../.} lib
      echo "Running lib/tests/modules.sh"
      bash lib/tests/modules.sh

      echo "Running lib/tests/filesystem.sh"
      TEST_LIB=$PWD/lib bash lib/tests/filesystem.sh

      echo "Running lib/tests/sources.sh"
      TEST_LIB=$PWD/lib bash lib/tests/sources.sh

      mkdir $out
      echo success > $out/${nix.version}
    '';

in
  pkgs.symlinkJoin {
    name = "nixpkgs-lib-tests";
    paths = map testWithNix nixVersions;
  }
