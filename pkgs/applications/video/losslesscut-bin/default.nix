{ lib
, callPackage
, buildPackages
, hostPlatform
}:

let
  pname = "losslesscut";
  version = "3.46.2";
  metaCommon = with lib; {
    description = "The swiss army knife of lossless video/audio editing";
    homepage = "https://mifi.no/losslesscut/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ShamrockLee ];
  };
  x86_64-appimage = callPackage ./build-from-appimage.nix {
    inherit pname version metaCommon;
    hash = "sha256-p+HscYsChR90JHdYjurY4OOHgveGXbJomz1klBCsF2Q=";
    inherit (buildPackages) makeWrapper;
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-350MHWwyjCdvIv6W6lX6Hr6PLDiAwO/e+KW0yKi/Yoc=";
  };
  x86_64-windows = callPackage ./build-from-windows.nix {
    inherit pname version metaCommon;
    hash = "sha256-48ifhvIWSPmmnBnW8tP7NeWPIWJYWNqGP925O50CAwQ=";
  };
in
(
  if hostPlatform.isDarwin then x86_64-dmg
  else if hostPlatform.isCygwin then x86_64-windows
  else x86_64-appimage
).overrideAttrs
  (oldAttrs: {
    passthru = (oldAttrs.passthru or { }) // {
      inherit x86_64-appimage x86_64-dmg x86_64-windows;
    };
    meta = oldAttrs.meta // {
      platforms = lib.unique (
        x86_64-appimage.meta.platforms
          ++ x86_64-dmg.meta.platforms
          ++ x86_64-windows.meta.platforms
      );
    };
  })
