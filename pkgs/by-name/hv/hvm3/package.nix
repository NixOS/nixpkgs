# TODO: hvml segfaults, probably issue with Haskell/Cabal dependency versions?
# /nix/store/94kvivsvfiwadzmd9x3xv89m3wph0na0-hvm3-unstable-2025-01-21/bin/hvml run hvm3/book/fuse_rot.hvml
# segmentation fault (core dumped)

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

  # TODO: passthru.updateScript = ./update.sh;
  # cabal2nix https://github.com/higherorderco/hvm3 > derivation.nix
  # nixfmt derivation.nix

  overrides = rec {
    pname = "hvm3";
    version = "unstable-2025-01-21";

    postPatch = ''
      sed -i -E \
        's/([a-zA-Z-]+)( *[>=\^].*,|,)/\1,/g' \
        HVM3.cabal
    '';

    # Test suite does nothing.
    doCheck = false;

    # maintainers = with lib.maintainers; [ joaomoreira ];
  };

  raw-pkg = haskellPackages.callPackage ./derivation.nix {
    c = glibc;
  };
in
lib.pipe raw-pkg [
  (overrideCabal overrides)
  justStaticExecutables
]
