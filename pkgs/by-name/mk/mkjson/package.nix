{ haskell, haskellPackages }:
haskell.lib.justStaticExecutables (haskellPackages.callPackage ./generated.nix { })
