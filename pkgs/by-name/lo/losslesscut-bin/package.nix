{
  lib,
  stdenv,
  callPackage,
  buildPackages,
}:

let
  pname = "losslesscut";
  version = "3.64.0";
  metaCommon = with lib; {
    description = "Swiss army knife of lossless video/audio editing";
    homepage = "https://mifi.no/losslesscut/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ShamrockLee ];
    mainProgram = "losslesscut";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
  x86_64-appimage = callPackage ./build-from-appimage.nix {
    inherit pname version metaCommon;
    hash = "sha256-K90cJuJFcIkPuAQusJcOBkZ5PQ8T25q7IFIhtmK+jzc=";
    inherit (buildPackages) makeWrapper;
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-BO2KoYAevbVL0Eix1knvaPVBkWucYI89VkueWYRTcXY=";
    isAarch64 = false;
  };
  aarch64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-/M5yafZQDqCoDzHpjZBC80CcL9KMO5lwvyCcq19caRg=";
    isAarch64 = true;
  };
  x86_64-windows = callPackage ./build-from-windows.nix {
    inherit pname version metaCommon;
    hash = "sha256-FYrnTiZ5ATT+Y08zceIIHbVM//5Bg2ozIEyC5UxmIno=";
  };
in
(
  if stdenv.hostPlatform.system == "aarch64-darwin" then
    aarch64-dmg
  else if stdenv.hostPlatform.isDarwin then
    x86_64-dmg
  else if stdenv.hostPlatform.isCygwin then
    x86_64-windows
  else
    x86_64-appimage
).overrideAttrs
  (oldAttrs: {
    passthru = (oldAttrs.passthru or { }) // {
      inherit
        x86_64-appimage
        x86_64-dmg
        aarch64-dmg
        x86_64-windows
        ;
    };
    meta = oldAttrs.meta // {
      platforms = lib.unique (
        x86_64-appimage.meta.platforms
        ++ x86_64-dmg.meta.platforms
        ++ aarch64-dmg.meta.platforms
        ++ x86_64-windows.meta.platforms
      );
    };
  })
