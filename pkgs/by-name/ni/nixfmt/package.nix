{
  haskell,
  haskellPackages,
  lib,
  runCommand,
  nixfmt,
}:
let
  inherit (haskell.lib.compose) overrideCabal justStaticExecutables;

  overrides = {
    passthru.updateScript = ./update.sh;

    teams = [ lib.teams.formatter ];

    # These tests can be run with the following command.
    #
    # $ nix-build -A nixfmt.tests
    passthru.tests = runCommand "nixfmt-tests" { nativeBuildInputs = [ nixfmt ]; } ''
      nixfmt --version > $out
    '';
  };
  raw-pkg = haskellPackages.callPackage ./generated-package.nix { };
in
lib.pipe raw-pkg [
  (overrideCabal overrides)
  justStaticExecutables
]
