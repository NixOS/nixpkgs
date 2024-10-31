{ callPackage, ... } @ args:
let
  unwrapped = callPackage ./unwrapped.nix (removeAttrs args [ "callPackage" ]);
in
  unwrapped.overrideAttrs (oldAttrs: {
    passthru =
      let
        finalKodi = oldAttrs.passthru.kodi;
        kodiPackages = callPackage ../../../top-level/kodi-packages.nix { kodi = finalKodi; };
      in
        oldAttrs.passthru // {
          packages = kodiPackages;
          withPackages = func: callPackage ./wrapper.nix {
            kodi = finalKodi;
            addons = kodiPackages.requiredKodiAddons (func kodiPackages);
          };
        };
  })
