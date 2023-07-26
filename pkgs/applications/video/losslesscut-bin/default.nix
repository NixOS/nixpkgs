{ lib
, stdenv
, callPackage
, buildPackages
}:

let
  pname = "losslesscut";
  version = "3.55.2";
  metaCommon = with lib; {
    description = "The swiss army knife of lossless video/audio editing";
    homepage = "https://mifi.no/losslesscut/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ShamrockLee ];
  };
  x86_64-appimage = callPackage ./build-from-appimage.nix {
    inherit pname version metaCommon;
    hash = "sha256-oQYDK/BHxC/zJuocDH+HcItcPQIsxAaKoD+49TAA+ds=";
    inherit (buildPackages) makeWrapper;
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-dmtnGv5XQn2ANpYyFu9jtTGr1b7GdDrV3Oajd5bMr0k=";
    isAarch64 = false;
  };
  aarch64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-uU48Clhk4FllM7osHRR4D7xGZCmcvylqlUt6JqCrm/8=";
    isAarch64 = true;
  };
  x86_64-windows = callPackage ./build-from-windows.nix {
    inherit pname version metaCommon;
    hash = "sha256-YkPF6sgL/oGXSXCdQt+7iW2n5f9Tk2ItchwRAwq7IPY=";
  };
in
(
  if stdenv.hostPlatform.system == "aarch64-darwin" then aarch64-dmg
  else if stdenv.hostPlatform.isDarwin then x86_64-dmg
  else if stdenv.hostPlatform.isCygwin then x86_64-windows
  else x86_64-appimage
).overrideAttrs
  (oldAttrs: {
    passthru = (oldAttrs.passthru or { }) // {
      inherit x86_64-appimage x86_64-dmg aarch64-dmg x86_64-windows;
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
