{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  tracy,

  # nativeBuildInputs
  cmake,
  ninja,
  qt6,

  # buildInputs
  aws-sdk-cpp,
  boost,
  bzip2,
  geos,
  geographiclib,
  glew,
  glm,
  gtest,
  howard-hinnant-date,
  libSM,
  libcpr,
  libpng,
  onetbb,
  openssl,
  python3,
  range-v3,
  re2,
  spdlog,
  stb,
  zlib,
}:
let
  gtestSkip = [
    # Skip tests requiring network access
    "AwsLevel*DataProvider.FindKeyFixed"
    "AwsLevel*DataProvider.FindKeyNow"
    "AwsLevel*DataProvider.GetAvailableProducts"
    "AwsLevel*DataProvider.GetTimePointsByDate"
    "AwsLevel*DataProvider.LoadObjectByKey"
    "AwsLevel*DataProvider.Prune"
    "AwsLevel*DataProvider.Refresh"
    "IemApiProviderTest.*"
    "NtpClient.*"
    "NwsApiProviderTest.*"
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
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "dpaulat";
    repo = "supercell-wx";
    tag = "v${finalAttrs.version}-release";
    fetchSubmodules = true;
    hash = "sha256-1n1WXBLco2TpyhS8KA1tk6HzRIXLqS6YV3aYagoQiTM=";
  };

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
    ./patches/fix-qt-6.10.patch
    ./patches/fix-find-opengl.patch
    # }}}
  ];

  # This also may be submitted upstream to maplibre-native-qt, which is currently vendored
  postPatch = ''
    substituteInPlace external/maplibre-native-qt/src/core/CMakeLists.txt \
      --replace-fail "CMAKE_SOURCE_DIR" "PROJECT_SOURCE_DIR"
  '';

  env = {
    CXXFLAGS = lib.concatStringsSep " " [
      "-Wno-error=deprecated-declarations"
      "-Wno-error=maybe-uninitialized"
      "-Wno-error=restrict"
      "-Wno-error=stringop-overflow"
      "-DQT_NO_USE_NODISCARD_FILE_OPEN"
    ];
    GTEST_FILTER = "-${lib.concatStringsSep ":" gtestSkip}";
  };

  cmakeFlags = [
    # CMake Error at external/aws-sdk-cpp/crt/aws-crt-cpp/cmake/EnforceSubmoduleVersions.cmake:18 (message):
    # ENFORCE_SUBMODULE_VERSIONS is ON but Git was not found.
    (lib.cmakeBool "ENFORCE_SUBMODULE_VERSIONS" false)

    # These tests aren't built by 'all', but ctest still tries to run them.
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "-E;'test_mln_core|test_mln_widgets'")
    (lib.cmakeFeature "STB_INCLUDE_DIR" "${stb}/include/stb")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TRACY" "${tracy.src}")
  ];

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    aws-sdk-cpp
    boost
    bzip2
    geos
    # FIXME: split outputs aren't working with find_package. Possibly related to nixpkgs/issues/144170 ?
    (geographiclib.overrideAttrs {
      outputs = [ "out" ];
    })
    glew
    glm
    gtest
    howard-hinnant-date
    libSM
    libcpr
    libpng
    onetbb
    openssl
    (python3.withPackages (ps: [
      ps.geopandas
      ps.jinja2
    ]))
    qt6.qtbase
    qt6.qtimageformats
    qt6.qtmultimedia
    qt6.qtpositioning
    qt6.qttools
    re2
    range-v3
    spdlog
    stb
    zlib
  ];

  # Currently crashes on wayland; must force X11
  qtWrapperArgs = [
    "--set QT_QPA_PLATFORM xcb"
  ];

  doCheck = true;

  # Install .desktop file and icons
  postInstall = ''
    install -m0644 -D "$src/scwx-qt/res/linux/supercell-wx.desktop" "$out/share/applications/supercell-wx.desktop"
    install -m0644 -D "$src/scwx-qt/res/icons/scwx-256.png"  "$out/share/icons/hicolor/256x256/apps/supercell-wx.png"
    install -m0644 -D "$src/scwx-qt/res/icons/scwx-64.png"  "$out/share/icons/hicolor/64x64/apps/supercell-wx.png"
  '';

  meta = {
    homepage = "https://supercell-wx.rtfd.io";
    downloadPage = "https://github.com/dpaulat/supercell-wx/releases";
    description = "Live visualization of NEXRAD weather data and alerts";
    changelog = "https://github.com/dpaulat/supercell-wx/releases/tag/${finalAttrs.src.tag}";
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
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ aware70 ];
  };
})
