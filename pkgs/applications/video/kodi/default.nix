{ lib, callPackage, kodiPackages, ... } @ args:
let
  unwrapped = callPackage ./unwrapped.nix (removeAttrs args [ "callPackage" "kodiPackages" ]);
in
  unwrapped.overrideAttrs (oldAttrs: {
    passthru = oldAttrs.passthru // {
      # avoid going in an inifite loop between kodi.packages -> kodiPackages.kodi -> ...
      packages = lib.dontRecurseIntoAttrs kodiPackages;
      withPackages = func: callPackage ./wrapper.nix {
        kodi = unwrapped;
        addons = kodiPackages.requiredKodiAddons (func kodiPackages);
      };
    };
  })
