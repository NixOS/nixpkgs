{
  nixpkgs ? ../../..,
  system ? builtins.currentSystem,
  pkgs ? import nixpkgs {
    config = {};
    overlays = [];
    inherit system;
  },
  libpath ? ../..,
  # Random seed
  seed ? null,
}:
pkgs.runCommand "lib-path-tests" {
  nativeBuildInputs = with pkgs; [
    nix
    jq
    bc
  ];
} ''
  # Needed to make Nix evaluation work
  export NIX_STATE_DIR=$(mktemp -d)

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
