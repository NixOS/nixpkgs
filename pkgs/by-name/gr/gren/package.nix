{
  lib,
  haskell,
  haskellPackages,
}:

let
  inherit (haskell.lib.compose) overrideCabal;

  raw-pkg = (haskellPackages.callPackage ./generated-package.nix { }).overrideScope (
    final: prev: {
      ansi-wl-pprint = final.ansi-wl-pprint_0_6_9;
    }
  );

  overrides = {
    maintainers = with lib.maintainers; [ tomasajt ];
    passthru.updateScript = ./update.sh;
  };
in
overrideCabal overrides raw-pkg
