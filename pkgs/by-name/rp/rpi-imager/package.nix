{
  lib,
  stdenv,
  cmake,
  curl,
  fetchFromGitHub,
  gnutls,
  libarchive,
  libusb1,
  libtasn1,
  liburing,
  nix-update-script,
  pkg-config,
  qt6,
  testers,
  wrapGAppsHook4,
  writeShellScriptBin,
  xz,
  zstd,
  enableTelemetry ? false,
  enableUring ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rpi-imager";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpi-imager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8zsWoS27NlhvKeLFUhYhjIKhOC8/O2RPYnRSxbnOiL0=";
  };

  postPatch = ''
        substituteInPlace debian/com.raspberrypi.rpi-imager.desktop \
          --replace-fail "/usr/bin/" ""

        substituteInPlace src/CMakeLists.txt \
          --replace-fail 'qt_add_lupdate(TS_FILES ''${TRANSLATIONS} SOURCE_TARGETS ''${PROJECT_NAME} OPTIONS -no-obsolete -locations none)' "" \
          --replace-fail 'include(dependencies/xz.cmake)' 'find_package(LibLZMA)' \
          --replace-fail 'include(dependencies/zstd.cmake)' 'find_package(zstd)' \
          --replace-fail 'include(dependencies/nghttp2.cmake)' "" \
          --replace-fail 'include(dependencies/zlib.cmake)' 'find_package(ZLIB)' \
          --replace-fail 'include(dependencies/libarchive.cmake)' 'find_package(LibArchive)' \
          --replace-fail 'include(dependencies/curl.cmake)' \
                       'find_package(CURL REQUIRED)
    set(CURL_INCLUDE_DIR ''${CURL_INCLUDE_DIRS})' \
          --replace-fail 'include(dependencies/libusb.cmake)' \
                       'find_package(PkgConfig)
    pkg_check_modules(LIBUSB libusb-1.0)
    set(LIBUSB_INCLUDE_DIR ''${LIBUSB_INCLUDE_DIRS} CACHE PATH "" FORCE)
    set(LIBUSB_LIBRARIES ''${LIBUSB_LINK_LIBRARIES} CACHE STRING "" FORCE)' \
          --replace-fail 'add_dependencies(''${PROJECT_NAME} zlibstatic yescrypt usb-1.0-static)' \
                         'add_dependencies(''${PROJECT_NAME} yescrypt)'
  '';

  preConfigure = ''
    cd src
  '';

  nativeBuildInputs =
    let
      # Fool upstream's cmake lsblk check a bit
      fake-lsblk = writeShellScriptBin "lsblk" ''
        echo "our lsblk has --json support but it doesn't work in our sandbox"
      '';

      # Upstream uses `git describe` to define a `IMAGER_VERSION` CMake variable,
      # and we fool it to take a version from a fake `git` executable.
      fake-git = writeShellScriptBin "git" ''
        echo "v${finalAttrs.version}"
      '';
    in
    [
      cmake
      fake-git
      fake-lsblk
      pkg-config
      qt6.wrapQtAppsHook
      wrapGAppsHook4
    ];

  buildInputs = [
    curl
    gnutls
    libarchive
    libtasn1
    libusb1
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qttools
    xz
    zstd
  ]
  ++ lib.optional enableUring liburing
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6.qtwayland
  ];

  cmakeFlags = [
    # Isn't relevant for Nix
    (lib.cmakeBool "ENABLE_CHECK_VERSION" false)
    (lib.cmakeBool "ENABLE_TELEMETRY" enableTelemetry)
    # Disable fetching external data files
    (lib.cmakeBool "GENERATE_CAPITAL_CITIES" false)
    (lib.cmakeBool "GENERATE_COUNTRIES_FROM_REGDB" false)
    (lib.cmakeBool "GENERATE_TIMEZONES_FROM_IANA" false)
  ];

  qtWrapperArgs = [
    "--unset QT_QPA_PLATFORMTHEME"
    "--unset QT_STYLE_OVERRIDE"
  ];

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  env.LANG = "C.UTF-8";

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "QT_QPA_PLATFORM=offscreen rpi-imager --version";
      version = "v${finalAttrs.version}";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Raspberry Pi Imaging Utility";
    homepage = "https://github.com/raspberrypi/rpi-imager/";
    changelog = "https://github.com/raspberrypi/rpi-imager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "rpi-imager";
    maintainers = with lib.maintainers; [
      anthonyroussel
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    # could not find xz
    badPlatforms = lib.platforms.darwin;
  };
})
