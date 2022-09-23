{ callPackage, ... } @ args:
let
  unwrapped = callPackage ./unwrapped.nix (removeAttrs args [ "callPackage" ]);
  kodiPackages = callPackage ../../../top-level/kodi-packages.nix { kodi = unwrapped; };
in
  unwrapped.overrideAttrs (oldAttrs: {
    passthru = oldAttrs.passthru // {
      packages = kodiPackages;
      withPackages = func: callPackage ./wrapper.nix {
        kodi = unwrapped;
        addons = kodiPackages.requiredKodiAddons (func kodiPackages);
      };
    };
  })
