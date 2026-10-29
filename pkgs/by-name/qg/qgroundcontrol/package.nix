{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cpm-cmake,
  geographiclib,
  libevents,
  mavlink-c-library-v2,
  sdl_gamecontrollerdb,
  shapelib,
  ulog-cpp,
  xz-embedded,
  zlib,
  ninja,
  SDL2,
  gst_all_1,
  wayland,
  pkg-config,
  nix-update-script,
  px4-gpsdrivers,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qgroundcontrol";
  version = "5.1.5";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mavlink";
    repo = "qgroundcontrol";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-dKIVxr+9UsGb8MHC7C04SThw9kiIsqYkSxO6kw0BF+0=";
  };

  patches = [
    ./disable-bad-message.patch # TODO: Upstream
    # Each of these replaces a CPMAddPackage call (which vendors+recompiles a
    # dependency's sources at build time, requiring network access) with the
    # real nixpkgs package, found via find_package.
    ./use-px4-gpsdrivers.patch
    ./use-nixpkgs-mavlink.patch
    ./use-nixpkgs-libevents.patch
    ./use-nixpkgs-sdl2.patch
    ./use-nixpkgs-compression.patch
    ./use-nixpkgs-geographiclib.patch
    ./use-nixpkgs-shapelib.patch
    # QGC's own FindGStreamer.cmake assumes a single FHS-style root
    # (/usr/lib/gstreamer-1.0, /usr/include); nixpkgs splits each component
    # into its own store path, so point it at the real ones directly.
    ./use-nixpkgs-gstreamer-root.patch
    # gstqml6gl vendors a copy of the ext/qt6 sources that gst-plugins-good's
    # own meson build already compiles into libgstqml6.so when built with
    # Qt6 support (which our gst-plugins-good buildInput is); rely on that
    # real, dynamically-loaded plugin instead of recompiling a second copy.
    # See prePatch below, which removes the vendored copy outright.
    ./use-nixpkgs-gst-qt6-sources.patch
    ./no-static-qml6-plugin.patch
  ];

  # Never let a vendored copy of a dependency's sources (checked into QGC's
  # own repo as a fallback) get built instead of the real nixpkgs package: it
  # would silently stop tracking overlays/updates to that package.
  prePatch = ''
    rm -rf src/VideoManager/VideoReceiver/GStreamer/gstqml6gl/qt6
  '';

  # Unvendor CPM. cpm-cmake's setup hook sets CPM_LOCAL_PACKAGES_ONLY, which
  # makes every remaining (unpatched) CPMAddPackage call resolve via
  # find_package against the real nixpkgs packages below instead of
  # attempting a network fetch (e.g. ulog_cpp, whose upstream CMake project
  # name happens to already match what find_package needs).
  postPatch = ''
    rm cmake/modules/CPM.cmake
    ln -s ${cpm-cmake}/share/cpm/CPM.cmake cmake/modules/CPM.cmake

    substituteInPlace src/Joystick/CMakeLists.txt \
      --replace-fail '@SDL_GAMECONTROLLERDB_FILE@' "${sdl_gamecontrollerdb}/share/gamecontrollerdb.txt"

    substituteInPlace src/MAVLink/LibEvents/CMakeLists.txt \
      --replace-fail '@LIBEVENTS_INCLUDE_DIR@' "${libevents}/include"
  '';

  nativeBuildInputs = [
    cmake
    cpm-cmake
    ninja
    pkg-config
  ] ++ (with qt6; [
    qttools
    wrapQtAppsHook
  ]);

  propagatedBuildInputs = with qt6; [
    qtbase
    qtcharts
    qtlocation
    qtserialport
    qtsvg
    qtspeech
    qtsensors
    qt5compat
  ];

  gstInputs = with gst_all_1; [
    gstreamer
    gst-plugins-base
    (gst-plugins-good.override { qt6Support = true; })
    gst-plugins-bad
    gst-libav
    wayland
  ];

  buildInputs = [
    SDL2
    geographiclib
    libevents
    mavlink-c-library-v2
    shapelib
    ulog-cpp
    px4-gpsdrivers
    xz-embedded
    zlib
  ]
  ++ finalAttrs.gstInputs
  ++ finalAttrs.propagatedBuildInputs;

  cmakeFlags = [
    # TODO: This needs rationale.
    (lib.cmakeBool "QGC_BUILD_STABLE" true)
    # Override maximum version to always accept the packaged qt6
    (lib.cmakeFeature "QGC_QT_MAXIMUM_VERSION" qt6.qtbase.version)
    # Default install tries to copy Qt files into package
    # TODO: Confirm this is still the case
    (lib.cmakeBool "QGC_DISABLE_BUILD_SETUP" true)
    # Disables an /etc/group check that has false positives on nixos
    (lib.cmakeBool "QGC_DISABLE_ETC_GROUP_CHECKS" true)
    # Tries to download x86_64-only prebuilt binaries
    # TODO: Confirm this is still the case
    (lib.cmakeBool "DISABLE_AIRMAP" true)
    # Qt's AUTOGEN machinery tries to add_dependencies() on every directly
    # linked library for its timestamp-tracking target, which fails for any
    # of them that's a plain IMPORTED target (as find_package Config-mode
    # targets are, e.g. GeographicLib::GeographicLib) since those have no
    # build step to depend on. AUTOGEN doesn't need this to work correctly.
    (lib.cmakeBool "CMAKE_AUTOGEN_ORIGIN_DEPENDS" false)
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/applications
    sed 's/Exec=.*/Exec=QGroundControl/' --in-place deploy/qgroundcontrol.desktop
    cp -v deploy/qgroundcontrol.desktop $out/share/applications

    mkdir -p $out/bin
    cp -v bin/QGroundControl $out/bin/

    mkdir -p $out/share/qgroundcontrol
    cp -rv resources/ $out/share/qgroundcontrol

    install -D resources/icons/qgroundcontrol.png -t $out/share/icons/hicolor/128x128/apps

    runHook postInstall
  '';

  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  # Plain nix-update doesn't treat "-dev" as a prerelease marker, so it
  # happily "upgrades" past real releases to QGC's unreleased dev-branch
  # snapshot tags (e.g. v5.2.0-dev, which has no GitHub Release at all) -
  # restrict to clean vX.Y.Z tags only.
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9]+\\.[0-9]+\\.[0-9]+)$"
    ];
  };

  meta = {
    description = "Provides full ground station support and configuration for the PX4 and APM Flight Stacks";
    homepage = "https://qgroundcontrol.com/";
    changelog = "https://github.com/mavlink/qgroundcontrol/blob/master/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      lopsided98
      pandapip1
    ];
    mainProgram = "QGroundControl";
  };
})
