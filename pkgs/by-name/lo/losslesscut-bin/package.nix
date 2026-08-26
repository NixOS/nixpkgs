{
  lib,
  stdenv,
  callPackage,
  buildPackages,
}:
let
  pname = "losslesscut";
  version = "3.69.0";
  metaCommon = {
    description = "Swiss army knife of lossless video/audio editing";
    homepage = "https://mifi.no/losslesscut/";
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
    hash = "sha256-F56q4nv/viWmVJpKcUR0EmtXwojO/DBwRvycYxOhJnY=";
    inherit (buildPackages) makeWrapper;
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-q4KNGmUsiVZhsVtoLYEQZWLg8R+ry4wtHkvyxP3d9ko=";
    isAarch64 = false;
  };
  aarch64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-x4AbSC3zvgOErMgXHVp9FsznDRWIhx40SxVarKOfpYs=";
    isAarch64 = true;
  };
  x86_64-windows = callPackage ./build-from-windows.nix {
    inherit pname version metaCommon;
    hash = "sha256-uvcQZXaZnhRg+RgFTjrUrjipVGmJLMahqXtBMfAoGOQ=";
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
