{
  stdenv,
  lib,
  fetchFromGitHub,
  bzip2,
  cmake,
  conan,
  ninja,
  zlib,
  openssl,
  curl,
  glew,
  geos,
  git,
  boost185,
  spdlog,
  libcpr,
  libpng,
  libSM,
  geographiclib,
  re2,
  gtest,
  glm,
  qtbase,
  qttools,
  qtmultimedia,
  qtpositioning,
  qtimageformats,
  tbb_2021_11,
  pkg-config,
  python3,
  wrapQtAppsHook,
}: let
  version = "0.4.4";
  src = fetchFromGitHub {
    owner = "dpaulat";
    repo = "supercell-wx";
    rev = "refs/tags/v${version}-release";
    sha256 = "sha256-HghyRFLKboztQEOsvN2VaSxxcuPPu1GIakBNWRIWBOk=";
    fetchSubmodules = true;
  };
in
  stdenv.mkDerivation {
    name = "supercell-wx";
    inherit version;
    inherit src;

    meta = {
      homepage = "https://supercell-wx.rtfd.io";
      downloadPage = "https://github.com/dpaulat/supercell-wx/releases";
      description = ''
        Supercell Wx is a free, open source application to visualize live and
        archive NEXRAD Level 2 and Level 3 data, and severe weather alerts.
        It displays continuously updating weather data on top of a responsive
        map, providing the capability to monitor weather events using
        reflectivity, velocity, and other products.
      '';
      license = with lib.licenses; [mit];
      mainProgram = "supercell-wx";
      platforms = ["x86_64-linux"];
    };

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

    patches = [
      ./patches/remove-conan.patch
      ./patches/fix-cmake-find-packages.patch
      ./patches/add-cstdint.patch
      ./patches/fix-zoned-time.patch
      ./patches/fix-git-versioning.patch
      ./patches/add-explicit-libpng.patch
      ./patches/fix-cmake-install.patch
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
