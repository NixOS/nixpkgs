{
  haskell,
  haskellPackages,
  lib,
}:
let
  inherit (haskell.lib.compose) overrideCabal justStaticExecutables;

  overrides.passthru.updateScript = ./update.sh;
  raw-pkg = haskellPackages.callPackage ./generated-package.nix { };
in
lib.pipe raw-pkg [
  (overrideCabal overrides)
  justStaticExecutables
]
