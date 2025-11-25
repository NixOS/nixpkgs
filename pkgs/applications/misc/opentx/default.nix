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
  avrdude,
  udevCheckHook,
}:

mkDerivation rec {
  pname = "opentx";
  version = "2.3.15";

  src = fetchFromGitHub {
    owner = "opentx";
    repo = "opentx";
    rev = "release/${version}";
    sha256 = "sha256-F3zykJhKuIpLQSTjn7mcdjEmgRAlwCZpkTaKQR9ve3g=";
  };

  patches = [
    # fix error "The LOCATION property may not be read from target" and ensure proper linking of Qt modules so build don't fail
    ./fix-cmake-qt-linking-and-location.patch
  ];
  nativeBuildInputs = [
    cmake
    gcc-arm-embedded
    python3Packages.pillow
    qttools
    udevCheckHook
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    SDL
  ];

  postPatch = ''
    sed -i companion/src/burnconfigdialog.cpp \
      -e 's|/usr/.*bin/dfu-util|${dfu-util}/bin/dfu-util|' \
      -e 's|/usr/.*bin/avrdude|${avrdude}/bin/avrdude|'

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail "cmake_policy(SET CMP0023 OLD)" "cmake_policy(SET CMP0023 NEW)"
    substituteInPlace companion/src/thirdparty/maxlibqt/src/widgets/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.10)"
  '';

  cmakeFlags = [
    "-DGTEST_ROOT=${gtest.src}/googletest"
    # XXX I would prefer to include these here, though we will need to file a bug upstream to get that changed.
    #"-DDFU_UTIL_PATH=${dfu-util}/bin/dfu-util"
    #"-DAVRDUDE_PATH=${avrdude}/bin/avrdude"

    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  doInstallCheck = true;

  meta = with lib; {
    description = "OpenTX Companion transmitter support software";
    longDescription = ''
      OpenTX Companion is used for many different tasks like loading OpenTX
      firmware to the radio, backing up model settings, editing settings and
      running radio simulators.
    '';
    mainProgram = "companion" + lib.concatStrings (lib.take 2 (lib.splitVersion version));
    homepage = "https://www.open-tx.org/";
    license = licenses.gpl2Only;
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [
      elitak
      lopsided98
    ];
  };

}
