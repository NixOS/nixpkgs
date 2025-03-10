# REFERENCE: pkgs/by-name/ni/nixfmt-rfc-style
{
  haskell,
  lib,
}:

let
  inherit (haskell.lib.compose) overrideCabal justStaticExecutables;

  # See kind-lang.cabal. GHC2024 >= ghc910.
  ghcVersion = "ghc910";
  haskellPackages = haskell.packages.${ghcVersion};

  # TODO: passthru.updateScript = ./update.sh;
  # cabal2nix https://github.com/higherorderco/kind.git > derivation.nix
  # nixfmt derivation.nix

  overrides = rec {
    version = "unstable-2024-12-09";

    postPatch = ''
      sed -i -E \
        's/([ ,]+[^ =]+)[ =^><]+[0-9.]+/\1/' \
        kind-lang.cabal
    '';

    # Test suite does nothing.
    doCheck = false;

    maintainers = with lib.maintainers; [ joaomoreira ];
  };

  raw-pkg = haskellPackages.callPackage ./derivation.nix { };
in
lib.pipe raw-pkg [
  (overrideCabal overrides)
  justStaticExecutables
]
