{ lib, mkDerivation, fetchFromGitHub
, cmake, gcc-arm-embedded, python3Packages
<<<<<<< HEAD
, qtbase, qtmultimedia, qttools, SDL, gtest
=======
, qtbase, qtmultimedia, qttranslations, SDL, gtest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dfu-util
}:

mkDerivation rec {
  pname = "edgetx";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "EdgeTX";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-bKMAyONy1Udd+2nDVEMrtIsnfqrNuBVMWU7nCqvZ+3E=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ cmake gcc-arm-embedded python3Packages.pillow qttools ];

  buildInputs = [ qtbase qtmultimedia SDL ];
=======
  nativeBuildInputs = [ cmake gcc-arm-embedded python3Packages.pillow ];

  buildInputs = [ qtbase qtmultimedia qttranslations SDL ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    sed -i companion/src/burnconfigdialog.cpp \
      -e 's|/usr/.*bin/dfu-util|${dfu-util}/bin/dfu-util|'
  '';

  cmakeFlags = [
    "-DGTEST_ROOT=${gtest.src}/googletest"
<<<<<<< HEAD
=======
    "-DQT_TRANSLATIONS_DIR=${qttranslations}/translations"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "-DDFU_UTIL_PATH=${dfu-util}/bin/dfu-util"
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  meta = with lib; {
    description = "EdgeTX Companion transmitter support software";
    longDescription = ''
      EdgeTX Companion is used for many different tasks like loading EdgeTX
      firmware to the radio, backing up model settings, editing settings and
      running radio simulators.
    '';
    homepage = "https://edgetx.org/";
    license = licenses.gpl2Only;
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ elitak lopsided98 wucke13 ];
  };

}
