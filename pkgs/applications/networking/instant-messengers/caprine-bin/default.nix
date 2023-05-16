{ lib, callPackage, stdenvNoCC }:
let
  pname = "caprine";
<<<<<<< HEAD
  version = "2.58.0";
=======
  version = "2.55.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  metaCommon = with lib; {
    description = "An elegant Facebook Messenger desktop app";
    homepage = "https://sindresorhus.com/caprine";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
  };
  x86_64-appimage = callPackage ./build-from-appimage.nix {
    inherit pname version metaCommon;
<<<<<<< HEAD
    sha256 = "7iK2RyA63okJLH2Xm97fFilJHzqFuP96xkUr2+ADbC4=";
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    sha256 = "RqK+fJJAt9W+m7zg6ZYI6PEAOa3V1UxsptEpG1qjibg=";
=======
    sha256 = "MMbyiLBrdMGENRq493XzkcsDoXr3Aq3rXAni1egkPbo=";
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    sha256 = "1txuSQk6tH0xsjPk5cWUVnaAw4XBOr1+Fel06NLKFfk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in
(if stdenvNoCC.isDarwin then x86_64-dmg else x86_64-appimage).overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or { }) // { inherit x86_64-appimage x86_64-dmg; };
  meta = oldAttrs.meta // {
    platforms = x86_64-appimage.meta.platforms ++ x86_64-dmg.meta.platforms;
<<<<<<< HEAD
    mainProgram = "caprine";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
})
