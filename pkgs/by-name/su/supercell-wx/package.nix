{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  aws-sdk-cpp,
  bzip2,
  cmake,
  ninja,
  zlib,
  openssl,
  curl,
  glew,
  geos,
  boost,
  spdlog,
  stb,
  libcpr_1_10_5,
  libpng,
  libSM,
  geographiclib,
  howard-hinnant-date,
  re2,
  gtest,
  glm,
  qt6,
  tbb_2021_11,
  tzdata,
  substituteAll,
  python3,
}:
let
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
stdenv.mkDerivation (finalAttrs: {
  pname = "supercell-wx";
  version = "0.4.4";
  src = fetchFromGitHub {
    owner = "dpaulat";
    repo = "supercell-wx";
    rev = "refs/tags/v${finalAttrs.version}-release";
    sha256 = "sha256-HghyRFLKboztQEOsvN2VaSxxcuPPu1GIakBNWRIWBOk=";
    fetchSubmodules = true;
  };

  meta = {
    homepage = "https://supercell-wx.rtfd.io";
    downloadPage = "https://github.com/dpaulat/supercell-wx/releases";
    description = "Live visualization of NEXRAD weather data and alerts";
    longDescription = ''
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

  env.CXXFLAGS = "-Wno-error=restrict -Wno-error=maybe-uninitialized -Wno-error=deprecated-declarations -Wno-error=stringop-overflow";
  env.GTEST_FILTER = "-${lib.concatStringsSep ":" gtestSkip}";

  doCheck = true;

  # These tests aren't built by 'all', but ctest still tries to run them.
  cmakeFlags = [
    "-DCMAKE_CTEST_ARGUMENTS=-E;'test_mln_core|test_mln_widgets'"
    "-DSTB_INCLUDE_DIR=${stb}/include/stb"
  ];

  patches = [
    # These are for Nix compatibility {{{
    ./patches/use-find-package.patch # Replace some vendored dependencies with Nix provided versions
    (substituteAll {
      # Skip tagging build with git version, and substitute it with the src revision (still uses current year timestamp)
      src = ./patches/skip-git-versioning.patch;
      rev = finalAttrs.src.rev;
    })
    # Prevents using some Qt scripts that seemed to break the install step. Fixes missing link to some targets.
    ./patches/fix-cmake-install.patch
    # }}}

    # These may be submitted upstream {{{
    ./patches/add-cstdint.patch # use <cstdint> for GCC 13 compatibility
    ./patches/fix-zoned-time.patch # fix ambiguity of some date/chrono functions in GCC 13
    # fix apparent logic error when checking for supported audio codecs on launch
    (fetchpatch {
      name = "fix-audio-codec-setup.diff";
      url = "https://github.com/dpaulat/supercell-wx/commit/9dfbac66172b882c5c4ccfa4251a03f8bf607b02.diff";
      sha256 = "sha256-sGw/vwJVNcWD56z/cG0VMZo+daQXb/I0+zbG3Gr18lU=";
    })
    ./patches/add-missing-algorithm-include-gcc14.patch
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
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    zlib
    openssl
    curl
    qt6.qtbase
    qt6.qttools
    qt6.qtmultimedia
    qt6.qtpositioning
    qt6.qtimageformats
    aws-sdk-cpp
    howard-hinnant-date
    boost
    tbb_2021_11
    glew
    geos
    spdlog
    stb
    libcpr_1_10_5
    libpng
    libSM
    re2
    openssl
    # FIXME: split outputs aren't working with find_package. Possibly related to nixpkgs/issues/144170 ?
    (geographiclib.overrideAttrs {
      outputs = [ "out" ];
    })
    gtest
    glm
    bzip2
    (python3.withPackages (ps: [
      ps.geopandas
    ]))
  ];
})
