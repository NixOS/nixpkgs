{
  haskell,
  haskellPackages,
  lib,
}:

let
  inherit (haskell.lib.compose) justStaticExecutables overrideCabal;

  generated = haskellPackages.callPackage ./generated.nix { };

  overrides = {
    passthru.updateScript = ./update.sh;

    description = "Purely functional programming language based on lambda calculus and de Bruijn indices";
    homepage = "https://bruijn.marvinborner.de/";
  };
in

lib.pipe generated [
  (overrideCabal overrides)
  justStaticExecutables
]
