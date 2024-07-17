{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  gcc-arm-embedded,
  python3Packages,
  qtbase,
  qtmultimedia,
  qttools,
  SDL,
  gtest,
  dfu-util,
}:

mkDerivation rec {
  pname = "edgetx";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "EdgeTX";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-bKMAyONy1Udd+2nDVEMrtIsnfqrNuBVMWU7nCqvZ+3E=";
  };

  nativeBuildInputs = [
    cmake
    gcc-arm-embedded
    python3Packages.pillow
    qttools
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    SDL
  ];

  postPatch = ''
    sed -i companion/src/burnconfigdialog.cpp \
      -e 's|/usr/.*bin/dfu-util|${dfu-util}/bin/dfu-util|'
  '';

  cmakeFlags = [
    "-DGTEST_ROOT=${gtest.src}/googletest"
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
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [
      elitak
      lopsided98
      wucke13
    ];
  };

}
