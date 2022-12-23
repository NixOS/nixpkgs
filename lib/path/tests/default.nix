{
  nixpkgs ? ../../..,
  system ? builtins.currentSystem,
  pkgs ? import nixpkgs {
    config = {};
    overlays = [];
    inherit system;
  },
  libpath ? ../..,
}:
pkgs.runCommand "lib-path-tests" {
  nativeBuildInputs = with pkgs; [
    nix
  ];
} ''
  # Needed to make Nix evaluation work
  export NIX_STATE_DIR=$(mktemp -d)

  cp -r ${libpath} lib
  export TEST_LIB=$PWD/lib

  echo "Running unit tests lib/path/tests/unit.nix"
  nix-instantiate --eval lib/path/tests/unit.nix \
    --argstr libpath "$TEST_LIB"

  touch $out
''
