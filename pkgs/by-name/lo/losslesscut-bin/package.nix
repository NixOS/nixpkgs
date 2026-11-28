{
  lib,
  stdenv,
  callPackage,
  buildPackages,
}:
let
  pname = "losslesscut";
  version = "3.70.2";
  metaCommon = {
    description = "Swiss army knife of lossless video/audio editing";
    homepage = "https://losslesscut.app/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      ShamrockLee
      Br1ght0ne
    ];
    mainProgram = "losslesscut";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
  x86_64-appimage = callPackage ./build-from-appimage.nix {
    inherit pname version metaCommon;
    hash = "sha256-6eoAyc9s3aENudnNE/ycoQ1hzcBGpg9e40DbZkMWSko=";
    inherit (buildPackages) makeWrapper;
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-VQT1se1IXWlJKfZNucQVFs/oZvXcX4uyr6rX2amdl1w=";
    isAarch64 = false;
  };
  aarch64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-PA4rPsJf7GbPDO80NFDZozPku6XWRFbDTNGOiRo/WUc=";
    isAarch64 = true;
  };
  x86_64-windows = callPackage ./build-from-windows.nix {
    inherit pname version metaCommon;
    hash = "sha256-F0DF8XuVLATPGxYSzzL1bGiogQXARRmVJsfqlnjTCbA=";
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
