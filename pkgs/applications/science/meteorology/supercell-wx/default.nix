{ gcc10Stdenv
, lib
, fetchFromGitHub
, cmake
, conan
, ninja
, zlib
, openssl
, curl
, glew
, geos
, boost
, spdlog
, libcpr
, geographiclib
, re2
, gtest
, glm
, qtbase
, qttools
, qtmultimedia
, qtpositioning
, qtimageformats
, tbb
, wrapQtAppsHook
} : let
  version = "0.4.3";
in gcc10Stdenv.mkDerivation {
  name = "supercell-wx";
  inherit version;

  src = fetchFromGitHub {
    owner = "dpaulat";
    repo = "supercell-wx";
    rev = "refs/heads/feature/conan-2";
    sha256 = "sha256-KEHIH84sKF3sFxsmLDzkaCP58tHCSNBFU2f7njTVyqw=";
    fetchSubmodules = true;
    deepClone = true;
  };

  nativeBuildInputs = [
    cmake
    conan
    ninja
    wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CONFIGURATION_TYPES=Release"
    "-G Ninja"
  ];

  preConfigure = ''
    export HOME=$TMP
  '';

  buildInputs = [
    zlib
    openssl
    curl
    qtbase
    qttools
    qtmultimedia
    qtpositioning
    qtimageformats
    boost
    glew
    geos
    spdlog
    libcpr
    re2
    geographiclib
    gtest
    glm
    tbb
  ];
}
