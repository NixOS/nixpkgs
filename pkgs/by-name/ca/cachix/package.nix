{
  lib,
  haskell,
  haskellPackages,
}:
let
  inherit (haskell.lib) compose;
in
lib.pipe haskellPackages.cachix [
  compose.justStaticExecutables
  (compose.overrideCabal { mainProgram = "cachix"; })
  lib.getBin
]
