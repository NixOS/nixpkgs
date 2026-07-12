{
  lib,
  haskell,
  haskellPackages,

  # Test dependencies
  cornelis,
  runCommand,
}:
let
  inherit (haskell.lib.compose) overrideCabal justStaticExecutables;
  overrides = {
    description = "agda-mode for Neovim";

    passthru = {
      tests = runCommand "cornelis-tests" { nativeBuildInputs = [ cornelis ]; } ''
        cornelis --help > $out
      '';
    };
  };
in
lib.pipe haskellPackages.cornelis [
  (overrideCabal overrides)

  # Reduce closure size
  justStaticExecutables
]
