{ callPackage, stdenvNoCC, lib }:
let
  appimage = callPackage ./appimage.nix { };
  dmg = callPackage ./dmg.nix { };
in (if stdenvNoCC.isDarwin then dmg else appimage).overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or { }) // { inherit appimage dmg; };
  meta = oldAttrs.meta // {
    platforms = appimage.meta.platforms ++ dmg.meta.platforms;
  };
})
