{ lib, haskellPackages, haskell, removeReferencesTo}:

let
  static = haskell.lib.compose.justStaticExecutables haskellPackages.emanote;
in
  (haskell.lib.overrideCabal static (drv: {
    buildTools = (drv.buildTools or []) ++ [ removeReferencesTo ];
  })).overrideAttrs (drv: rec {
    disallowedReferences = [ haskellPackages.pandoc haskellPackages.pandoc-types haskellPackages.warp];
    postInstall = lib.concatStrings (map (e: "remove-references-to -t ${e} $out/bin/emanote\n") disallowedReferences);
  })
