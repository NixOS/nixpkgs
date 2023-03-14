{ lib
, stdenv
, callPackage
, buildPackages
}:

let
  pname = "losslesscut";
  version = "3.48.2";
  metaCommon = with lib; {
    description = "The swiss army knife of lossless video/audio editing";
    homepage = "https://mifi.no/losslesscut/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ShamrockLee ];
  };
  x86_64-appimage = callPackage ./build-from-appimage.nix {
    inherit pname version metaCommon;
    hash = "sha256-5T5+eBVbyOI89YA9NMLWweHagD09RB3P03HFvaDAOZ8=";
    inherit (buildPackages) makeWrapper;
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-PzjE0oJOuPG0S+mA7pgNU3MRgaE2jAPxWEN9J4PfqMQ=";
    isAarch64 = false;
  };
  aarch64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    hash = "sha256-927CSczgFJcbBJm2cYXucFRidkGAtcowoLMlm2GTafc=";
    isAarch64 = true;
  };
  x86_64-windows = callPackage ./build-from-windows.nix {
    inherit pname version metaCommon;
    hash = "sha256-+isxkGKxW7H+IjuA5G4yXuvDmX+4UlsD8sXwoHxgLM8=";
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
