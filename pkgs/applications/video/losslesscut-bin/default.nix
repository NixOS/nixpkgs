{ lib
, stdenv
, callPackage
, buildPackages
}:

let
  pname = "losslesscut";
<<<<<<< HEAD
  version = "3.55.2";
=======
  version = "3.48.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  metaCommon = with lib; {
    description = "The swiss army knife of lossless video/audio editing";
    homepage = "https://mifi.no/losslesscut/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ShamrockLee ];
  };
  x86_64-appimage = callPackage ./build-from-appimage.nix {
    inherit pname version metaCommon;
<<<<<<< HEAD
    hash = "sha256-oQYDK/BHxC/zJuocDH+HcItcPQIsxAaKoD+49TAA+ds=";
=======
    hash = "sha256-5T5+eBVbyOI89YA9NMLWweHagD09RB3P03HFvaDAOZ8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit (buildPackages) makeWrapper;
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
<<<<<<< HEAD
    hash = "sha256-dmtnGv5XQn2ANpYyFu9jtTGr1b7GdDrV3Oajd5bMr0k=";
=======
    hash = "sha256-PzjE0oJOuPG0S+mA7pgNU3MRgaE2jAPxWEN9J4PfqMQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    isAarch64 = false;
  };
  aarch64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
<<<<<<< HEAD
    hash = "sha256-uU48Clhk4FllM7osHRR4D7xGZCmcvylqlUt6JqCrm/8=";
=======
    hash = "sha256-927CSczgFJcbBJm2cYXucFRidkGAtcowoLMlm2GTafc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    isAarch64 = true;
  };
  x86_64-windows = callPackage ./build-from-windows.nix {
    inherit pname version metaCommon;
<<<<<<< HEAD
    hash = "sha256-YkPF6sgL/oGXSXCdQt+7iW2n5f9Tk2ItchwRAwq7IPY=";
=======
    hash = "sha256-+isxkGKxW7H+IjuA5G4yXuvDmX+4UlsD8sXwoHxgLM8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
