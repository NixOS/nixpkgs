{
  haskell,
  haskellPackages,
  lib,
}:
let
  inherit (haskell.lib.compose) justStaticExecutables overrideCabal;

  # The mkjson-doctest suite depends on specific RNG results not provided by the
  # GHC in Nixpkgs as of this writing.
  overrides = {
    testTargets = [ "mkjson-test" ];
  };
  raw-pkg = haskellPackages.callPackage ./generated.nix { };
in
lib.pipe raw-pkg [
  (overrideCabal overrides)
  justStaticExecutables
]
