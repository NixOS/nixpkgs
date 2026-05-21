{ callPackage, ... }@args:
let
  unwrapped = callPackage ./unwrapped.nix (removeAttrs args [ "callPackage" ]);
in
unwrapped.overrideAttrs (oldAttrs: {
  passthru =
    let
      finalKodi = oldAttrs.passthru.kodi;
    in
    oldAttrs.passthru
    // {
      packages = callPackage ../../../top-level/kodi-packages.nix { kodi = finalKodi; };
      withPackages =
        func:
        callPackage ./wrapper.nix {
          kodi = finalKodi;
          addons = finalKodi.packages.requiredKodiAddons (func finalKodi.packages);
        };
    };
})
