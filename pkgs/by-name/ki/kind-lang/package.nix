{
  haskell,
  lib,
}:

let
  inherit (haskell.lib.compose) overrideCabal justStaticExecutables;

  # See kind-lang.cabal. GHC2024 >= ghc910.
  ghcVersion = "ghc910";
  haskellPackages = haskell.packages.${ghcVersion};

  overrides = {
    version = "${raw-pkg.version}-unstable-2024-12-09";

    postPatch = ''
      sed -i -E \
        's/([ ,]+[^ =]+)[ =^><]+[0-9.]+/\1/' \
        kind-lang.cabal
    '';

    # Test suite does nothing.
    doCheck = false;

    maintainers = with lib.maintainers; [ joaomoreira ];
  };

  # cabal2nix auto-generated derivation.nix.
  raw-pkg = haskellPackages.callPackage ./derivation.nix { };
in
lib.pipe raw-pkg [
  (overrideCabal overrides)
  justStaticExecutables
]
