/**
  Instantiate the library tests for a given Nix version.

  IMPORTANT:
  This is used by the github.com/NixOS/nix CI.

  Try not to change the interface of this file, or if you need to, ping the
  Nix maintainers for help. Thank you!
*/
{
  pkgs,
  lib,
  # Only ever use this nix; see comment at top
  nix,
}:

pkgs.runCommand "nixpkgs-lib-tests-nix-${nix.version}"
  {
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
      pkgs.gitMinimal
    ] ++ lib.optional pkgs.stdenv.isLinux pkgs.inotify-tools;
    strictDeps = true;
  }
  ''
    datadir="${nix}/share"
    export TEST_ROOT=$(pwd)/test-tmp
    export HOME=$(mktemp -d)
    export NIX_BUILD_HOOK=
    export NIX_CONF_DIR=$TEST_ROOT/etc
    export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
    export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
    export NIX_STATE_DIR=$TEST_ROOT/var/nix
    export NIX_STORE_DIR=$TEST_ROOT/store
    export PAGER=cat
    cacheDir=$TEST_ROOT/binary-cache

    nix-store --init

    cp -r ${../.} lib
    echo "Running lib/tests/modules.sh"
    bash lib/tests/modules.sh

    echo "Checking lib.version"
    nix-instantiate lib -A version --eval || {
      echo "lib.version does not evaluate when lib is isolated from the rest of the nixpkgs tree"
      exit 1
    }

    echo "Running lib/tests/filesystem.sh"
    TEST_LIB=$PWD/lib bash lib/tests/filesystem.sh

    echo "Running lib/tests/sources.sh"
    TEST_LIB=$PWD/lib bash lib/tests/sources.sh

    echo "Running lib/fileset/tests.sh"
    TEST_LIB=$PWD/lib bash lib/fileset/tests.sh

    echo "Running lib/tests/systems.nix"
    [[ $(nix-instantiate --eval --strict lib/tests/systems.nix | tee /dev/stderr) == '[ ]' ]];

    mkdir $out
    echo success > $out/${nix.version}
  ''
