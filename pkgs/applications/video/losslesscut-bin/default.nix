{ callPackage, stdenvNoCC, lib }:
let
  version = "3.33.1";
  appimage = callPackage ./appimage.nix { inherit version; };
  dmg = callPackage ./dmg.nix { inherit version; };
  windows = callPackage ./windows.nix { inherit version; };
in (
  if stdenvNoCC.isDarwin then dmg
  else if stdenvNoCC.isCygwin then windows
  else appimage
).overrideAttrs
(oldAttrs: {
  meta = with lib; {
    description = "The swiss army knife of lossless video/audio editing";
    homepage = "https://mifi.no/losslesscut/";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
  } // oldAttrs.meta // {
    platforms =
      appimage.meta.platforms
      ++ dmg.meta.platforms
      ++ windows.meta.platforms;
  };
})
