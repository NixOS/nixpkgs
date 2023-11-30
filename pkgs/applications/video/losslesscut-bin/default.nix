{ lib
, stdenv
, callPackage
, buildPackages
}:

let
  pname = "losslesscut";
  version = "3.58.0";
  metaCommon = with lib; {
    description = "The swiss army knife of lossless video/audio editing";
    homepage = "https://mifi.no/losslesscut/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ShamrockLee ];
    mainProgram = "losslesscut";
  };
  x86_64-appimage = callPackage ./build-from-appimage.nix {
    inherit pname version metaCommon;
    hash = "sha256-wmOdW5LdGLs6Wrt/VBlbC1ScFZBmd5gVQaj/cYADnWc=";
    inherit (buildPackages) makeWrapper;
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-ZNUkzxpFTmsFcdC4oJWDxvqunpaBKz7Fnmrsa4W12Bg=";
    isAarch64 = false;
  };
  aarch64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-PpQF31qsn9TOIRVzOdDoLUqti+m1uRpBQrrqKtxFleE=";
    isAarch64 = true;
  };
  x86_64-windows = callPackage ./build-from-windows.nix {
    inherit pname version metaCommon;
    hash = "sha256-AgWvLU9m2q7fxZYXgHGMgEj1WLP5XzERq7tWcin2/30=";
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
