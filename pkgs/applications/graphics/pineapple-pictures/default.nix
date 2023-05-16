{ lib
, stdenv
, fetchFromGitHub
, qtsvg
<<<<<<< HEAD
, qtwayland
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, qttools
, exiv2
, wrapQtAppsHook
, cmake
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "pineapple-pictures";
  version = "0.7.2";
=======
stdenv.mkDerivation rec {
  pname = "pineapple-pictures";
  version = "0.6.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "BLumia";
    repo = "pineapple-pictures";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-dD0pHqw1Gxp+yxzYdm2ZgxiHKyuJKBGYpjv99B1Da1g=";
=======
    rev = version;
    sha256 = "sha256-QFKo4zMqhKzFseXMnZEBd2DPo0QObpelvYmI2tMyfRE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtsvg
<<<<<<< HEAD
    qtwayland
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    exiv2
  ];

  cmakeFlags = [
    "-DPREFER_QT_5=OFF"
  ];

<<<<<<< HEAD
  meta = {
    description = "Homebrew lightweight image viewer";
    homepage = "https://github.com/BLumia/pineapple-pictures";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "ppic";
    maintainers = with lib.maintainers; [ rewine ];
  };
})
=======
  meta = with lib; {
    description = "Homebrew lightweight image viewer";
    homepage = "https://github.com/BLumia/pineapple-pictures";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
