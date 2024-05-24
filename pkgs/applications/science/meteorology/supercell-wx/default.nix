{
  stdenv,
  lib,
  fetchFromGitHub,
  aws-sdk-cpp,
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
  stb,
  libcpr,
  libpng,
  libSM,
  geographiclib,
  howard-hinnant-date,
  re2,
  gtest,
  glm,
  qtbase,
  qttools,
  qtmultimedia,
  qtpositioning,
  qtimageformats,
  tbb_2021_11,
  tzdata,
  substituteAll,
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
      license = lib.licenses.mit;
      mainProgram = "supercell-wx";
      platforms = ["x86_64-linux"];
    };

    env.NIX_CFLAGS_COMPILE = "-Wno-error=restrict";

    patches = [
      ./patches/use-find-package.patch
      ./patches/add-cstdint.patch
      ./patches/fix-zoned-time.patch
      (substituteAll {
        src = ./patches/skip-git-versioning.patch;
        rev = src.rev;
      })
      ./patches/fix-cmake-install.patch
    ];

    postPatch = ''
      substituteInPlace external/maplibre-native-qt/src/core/CMakeLists.txt \
        --replace-fail "CMAKE_SOURCE_DIR" "PROJECT_SOURCE_DIR"
    '';

    nativeBuildInputs = [
      cmake
      ninja
      wrapQtAppsHook
      pkg-config
      git
    ];

    buildInputs = [
      zlib
      openssl
      curl
      qtbase
      qttools
      qtmultimedia
      qtpositioning
      qtimageformats
      aws-sdk-cpp
      howard-hinnant-date
      boost185
      tbb_2021_11
      glew
      geos
      spdlog
      stb
      libcpr
      libpng
      libSM
      re2
      openssl
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
