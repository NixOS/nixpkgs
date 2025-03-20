{
  nixpkgs ? ../../..,
  system ? builtins.currentSystem,
  pkgs ? import nixpkgs {
    config = { };
    overlays = [ ];
    inherit system;
  },
  nixVersions ? import ../../tests/nix-for-tests.nix { inherit pkgs; },
  libpath ? ../..,
  # Random seed
  seed ? null,
}:

pkgs.runCommand "lib-path-tests"
  {
    nativeBuildInputs =
      [
        nixVersions.stable
      ]
      ++ (with pkgs; [
        jq
        bc
      ]);
  }
  ''
    # Needed to make Nix evaluation work
    export TEST_ROOT=$(pwd)/test-tmp
    export NIX_BUILD_HOOK=
    export NIX_CONF_DIR=$TEST_ROOT/etc
    export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
    export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
    export NIX_STATE_DIR=$TEST_ROOT/var/nix
    export NIX_STORE_DIR=$TEST_ROOT/store
    export PAGER=cat

    cp -r ${libpath} lib
    export TEST_LIB=$PWD/lib

    echo "Running unit tests lib/path/tests/unit.nix"
    nix-instantiate --eval --show-trace \
      --argstr libpath "$TEST_LIB" \
      lib/path/tests/unit.nix

    echo "Running property tests lib/path/tests/prop.sh"
    bash lib/path/tests/prop.sh ${toString seed}

    touch $out
  ''
