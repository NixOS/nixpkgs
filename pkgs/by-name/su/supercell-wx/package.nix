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
  libcpr,
  libpng,
  libSM,
  geographiclib,
  howard-hinnant-date,
  re2,
  gtest,
  glm,
  qt6,
  tbb_2022,
  tracy,
  replaceVars,
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
    "MarkerModelTest.*"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "supercell-wx";
  version = "0.4.9";
  src = fetchFromGitHub {
    owner = "dpaulat";
    repo = "supercell-wx";
    rev = "refs/tags/v${finalAttrs.version}-release";
    sha256 = "sha256-3fVUxbGosN4Y4h8BJXUV7DNv7VZTma+IsV94+Zt8DCA=";
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
    platforms = [
      "x86_64-linux"
      #     "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ aware70 ];
  };

  env.CXXFLAGS = "-Wno-error=restrict -Wno-error=maybe-uninitialized -Wno-error=deprecated-declarations -Wno-error=stringop-overflow";
  env.GTEST_FILTER = "-${lib.concatStringsSep ":" gtestSkip}";

  doCheck = true;

  # These tests aren't built by 'all', but ctest still tries to run them.
  cmakeFlags = [
    "-DCMAKE_CTEST_ARGUMENTS=-E;'test_mln_core|test_mln_widgets'"
    "-DSTB_INCLUDE_DIR=${stb}/include/stb"
    "-DFETCHCONTENT_SOURCE_DIR_TRACY=${tracy.src}"
  ];

  patches = [
    # These are for Nix compatibility {{{
    ./patches/use-find-package.patch # Replace some vendored dependencies with Nix provided versions
    (replaceVars ./patches/skip-git-versioning.patch {
      # Skip tagging build with git version, and substitute it with the src revision (still uses current year timestamp)
      rev = finalAttrs.src.rev;
    })
    # Prevents using some Qt scripts that seemed to break the install step. Fixes missing link to some targets.
    ./patches/fix-cmake-install.patch
    # }}}

    # These may be or already are submitted upstream {{{
    ./patches/explicit-link-aws-crt.patch # fix missing symbols from aws-crt-cpp
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
    qt6.qtbase
    qt6.qttools
    qt6.qtmultimedia
    qt6.qtpositioning
    qt6.qtimageformats
    aws-sdk-cpp
    howard-hinnant-date
    boost
    tbb_2022
    glew
    geos
    spdlog
    stb
    libcpr
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

  # Currently crashes on wayland; must force X11
  qtWrapperArgs = [
    "--set QT_QPA_PLATFORM xcb"
  ];

  # Install .desktop file and icons
  postInstall = ''
    install -m0644 -D "$src/scwx-qt/res/linux/supercell-wx.desktop" "$out/share/applications/supercell-wx.desktop"
    install -m0644 -D "$src/scwx-qt/res/icons/scwx-256.png"  "$out/share/icons/hicolor/256x256/apps/supercell-wx.png"
    install -m0644 -D "$src/scwx-qt/res/icons/scwx-64.png"  "$out/share/icons/hicolor/64x64/apps/supercell-wx.png"
  '';
})
