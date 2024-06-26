{
  stdenv,
  lib,
  fetchFromGitHub,
  aws-sdk-cpp,
  bzip2,
  cmake,
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
  python3,
  wrapQtAppsHook,
}:
let
  version = "0.4.4";
  src = fetchFromGitHub {
    owner = "dpaulat";
    repo = "supercell-wx";
    rev = "refs/tags/v${version}-release";
    sha256 = "sha256-HghyRFLKboztQEOsvN2VaSxxcuPPu1GIakBNWRIWBOk=";
    fetchSubmodules = true;
  };

  gtestSkip = [
    # Skip tests requiring network access
    "AwsLevel*DataProvider.FindKeyNow"
    "AwsLevel*DataProvider.FindKeyFixed"
    "AwsLevel*DataProvider.LoadObjectByKey"
    "AwsLevel*DataProvider.Refresh"
    "AwsLevel*DataProvider.GetAvailableProducts"
    "AwsLevel*DataProvider.GetTimePointsByDate"
    "AwsLevel*DataProvider.Prune"
    "UpdateManagerTest.CheckForUpdates"
    "WarningsProvider*\"https"

    # These tests are failing (seemingly can't overwrite a file created by earlier test).
    "SettingsManager/DefaultSettingsTest*"
    "SettingsManager/BadSettingsTest*"
  ];
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
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ aware70 ];
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error=restrict";
  env.GTEST_FILTER = "-${lib.concatStringsSep ":" gtestSkip}";

  doCheck = true;

  # These tests aren't built by 'all', but ctest still tries to run them.
  cmakeFlags = [ "-DCMAKE_CTEST_ARGUMENTS=-E;'test_mln_core|test_mln_widgets'" ];

  patches = [
    # These are for Nix compatibility {{{
    ./patches/use-find-package.patch               # Replace some vendored dependencies with Nix provided versions
    (substituteAll {                               # Skip tagging build with git version, and substitute it with the src revision (still uses current year timestamp)
      src = ./patches/skip-git-versioning.patch;
      rev = src.rev;
    })
    ./patches/fix-cmake-install.patch     # prevents using some Qt scripts that seemed to break
                                          # the install step. Fixes missing link to some targets
    # }}}

    # These may be submitted upstream {{{
    ./patches/add-cstdint.patch           # use <cstdint> for GCC 13 compatibility
    ./patches/fix-zoned-time.patch        # fix ambiguity of some date/chrono functions in GCC 13
    ./patches/fix-audio-codec-setup.patch # fix apparent logic error when checking for supported audio codecs on launch
    # }}}
  ];

  # This also may be submitted upstream to maplibre-native-qt, which is currently vendored
  postPatch = ''
    substituteInPlace external/maplibre-native-qt/src/core/CMakeLists.txt \
      --replace-fail "CMAKE_SOURCE_DIR" "PROJECT_SOURCE_DIR"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    wrapQtAppsHook
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
