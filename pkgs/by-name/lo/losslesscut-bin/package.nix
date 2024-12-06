{ lib
, stdenv
, callPackage
, buildPackages
}:

let
  pname = "losslesscut";
  version = "3.61.1";
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
    hash = "sha256-wKhEB+MfOsBvZRTIt3hLofw37+YO+hWKowlSi1OxSAU=";
    inherit (buildPackages) makeWrapper;
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-yZYmM533D9VzM+a0bnYz/aqocaEJVFOTgLWjbQGOQR0=";
    isAarch64 = false;
  };
  aarch64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-/qa2P0R7xRzDgnPKqkeKN6lrDbPg9WuZ/Nnc51NTzaM=";
    isAarch64 = true;
  };
  x86_64-windows = callPackage ./build-from-windows.nix {
    inherit pname version metaCommon;
    hash = "sha256-0awYmSGxm8M12X0WQftlapRF9m3GGCZivNwBtRjSa4E=";
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
