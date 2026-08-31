{
  haskell,
  lib,
  glibc,
}:

let
  inherit (haskell.lib.compose) overrideCabal justStaticExecutables;

  # See HVM3.cabal. GHC2024 >= ghc910.
  ghcVersion = "ghc910";
  haskellPackages = haskell.packages.${ghcVersion};

  overrides = {
    pname = "hvm3";
    version = "${raw-pkg.version}-unstable-2025-03-18";

    postPatch = ''
      sed -i -E \
        's/([a-zA-Z0-9_-]+) (\^>=|==)[^,]*,/\1,/g' \
        HVM3.cabal
    '';

    # Test suite does nothing.
    doCheck = false;

    maintainers = with lib.maintainers; [ joaomoreira ];
  };

  # cabal2nix auto-generated derivation.nix
  raw-pkg = haskellPackages.callPackage ./derivation.nix {
    c = glibc;
  };
in
lib.pipe raw-pkg [
  (overrideCabal overrides)
  justStaticExecutables
]
