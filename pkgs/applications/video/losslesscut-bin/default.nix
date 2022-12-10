{ callPackage, stdenvNoCC, lib }:
let
  version = "3.46.2";
  appimage = callPackage ./appimage.nix { inherit version; sha256 = "sha256-p+HscYsChR90JHdYjurY4OOHgveGXbJomz1klBCsF2Q="; };
  dmg = callPackage ./dmg.nix { inherit version; sha256 = "sha256-350MHWwyjCdvIv6W6lX6Hr6PLDiAwO/e+KW0yKi/Yoc="; };
  windows = callPackage ./windows.nix { inherit version; sha256 = "sha256-48ifhvIWSPmmnBnW8tP7NeWPIWJYWNqGP925O50CAwQ="; };
in (
  if stdenvNoCC.isDarwin then dmg
  else if stdenvNoCC.isCygwin then windows
  else appimage
).overrideAttrs
(oldAttrs: {
  meta = with lib; {
    description = "The swiss army knife of lossless video/audio editing";
    homepage = "https://mifi.no/losslesscut/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ShamrockLee ];
  } // oldAttrs.meta // {
    platforms =
      appimage.meta.platforms
      ++ dmg.meta.platforms
      ++ windows.meta.platforms;
  };
})
