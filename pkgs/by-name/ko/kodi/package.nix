{ callPackage, kodiPackagesFile, ... }@args:
let
  unwrapped = callPackage ./unwrapped.nix (
    removeAttrs args [
      "callPackage"
      "kodiPackagesFile"
    ]
  );
in
unwrapped.overrideAttrs (oldAttrs: {
  passthru =
    let
      finalKodi = oldAttrs.passthru.kodi;
      kodiPackages = callPackage kodiPackagesFile { kodi = finalKodi; };
    in
    oldAttrs.passthru
    // {
      packages = kodiPackages;
      withPackages =
        func:
        callPackage ./wrapper.nix {
          kodi = finalKodi;
          addons = kodiPackages.requiredKodiAddons (func kodiPackages);
        };
    };
})
