{ stdenv
, lib
, fetchFromGitHub
, bzip2
, cmake
, conan
, ninja
, zlib
, openssl
, curl
, glew
, geos
, git
, boost185
, spdlog
, libcpr
, libpng
, libSM
, geographiclib
, re2
, gtest
, glm
, qtbase
, qttools
, qtmultimedia
, qtpositioning
, qtimageformats
, tbb_2021_11
, pkg-config
, python3
, wrapQtAppsHook
} : let

  version = "0.4.4";
  src = fetchFromGitHub {
    owner = "dpaulat";
    repo = "supercell-wx";
    rev = "refs/tags/v${version}-release";
    sha256 = "sha256-HghyRFLKboztQEOsvN2VaSxxcuPPu1GIakBNWRIWBOk=";
    fetchSubmodules = true;
  };

in stdenv.mkDerivation {
  name = "supercell-wx";
  inherit version;
  inherit src;

  nativeBuildInputs = [
    cmake
    ninja
    wrapQtAppsHook
    pkg-config
    git
  ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error=restrict"
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CONFIGURATION_TYPES=Release"
    "-DBUILD_SHARED_LIBS=ON"
    "-DMLN_QT_WITH_INTERNAL_SQLITE=ON"
    "-G Ninja"
  ];

  patches = [
    ./remove-conan.patch
    ./fix-cmake-find-packages.patch
    ./add-cstdint.patch
    ./fix-zoned-time.patch
    ./fix-git-versioning.patch
    ./add-explicit-libpng.patch
    ./fix-cmake-install.patch
  ];

  postPatch = ''
    substituteInPlace external/maplibre-native-qt/src/core/CMakeLists.txt \
      --replace-fail "CMAKE_SOURCE_DIR" "PROJECT_SOURCE_DIR"
    substituteInPlace scwx-qt/tools/generate_versions.py \
      --replace-fail "@NIX_SRC_REV@" "${src.rev}"
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
    boost185
    tbb_2021_11
    glew
    geos
    spdlog
    libcpr
    libpng
    libSM
    re2
    geographiclib
    gtest
    glm
    bzip2
    (python3.withPackages (ps: [
      ps.geopandas
      ps.gitpython
    ]))
  ];
}
