{
  haskell,
  haskellPackages,
  lib,
}:
let
  inherit (haskell.lib.compose) overrideCabal justStaticExecutables;

  overrides = {
    description = "OAuth credential MAnager";
    homepage = "https://github.com/pdobsan/oama";
    maintainers = with lib.maintainers; [ aidalgol ];

    passthru.updateScript = ./update.sh;
  };

  raw-pkg = (haskellPackages.callPackage ./generated-package.nix { }).overrideScope (
    final: prev: {
      # Dependency twain requires an older version of http2, and we cannot mix
      # versions of transitive dependencies.
      http2 = final.http2_3_0_3;
      warp = final.warp_3_3_30;
    }
  );
in
lib.pipe raw-pkg [
  (overrideCabal overrides)
  justStaticExecutables
]
