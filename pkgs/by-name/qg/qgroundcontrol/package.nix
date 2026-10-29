{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cpm-cmake,
  geographiclib,
  git,
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
    # cmake/Git.cmake assumes a .git checkout is always present to derive
    # QGC_APP_VERSION etc.; our source tarball has none, which crashed a
    # string(FIND) call downstream. Let these be pre-set via cache
    # variables instead of just falling back to git when there's no .git.
    ./no-git-info-crash.patch
    # src/QtLocationPlugin links Qt6::LocationPrivate, but LocationPrivate
    # was never added to the top-level find_package(Qt6 COMPONENTS ...)
    # list, so the target doesn't exist. A real upstream oversight, not a
    # Nix-specific issue - CMake's package resolution doesn't pull in
    # private modules as a side effect of requesting the public one.
    ./find-qt-location-private.patch
    # 5 files use QElapsedTimer without including it directly (it happens to
    # come in transitively through some other Qt header on the Qt version
    # upstream's CI uses, but not reliably - a real upstream bug, not
    # Nix-specific). TODO: Upstream.
    ./missing-qelapsedtimer-includes.patch
    # getuid() is POSIX, declared in unistd.h, which main.cc never includes
    # (another case of relying on transitive inclusion that doesn't hold
    # here). TODO: Upstream.
    ./missing-unistd-include.patch
    # Newer Qt6 (6.9+; we're on 6.12, past QGC_QT_MAXIMUM_VERSION's 6.8.3
    # cap, which we override) made QFlags's implicit int conversion
    # explicit-only, breaking this QString::arg() overload resolution. A
    # real forward-compat gap, not Nix-specific. TODO: Upstream.
    ./qflags-arg-overload.patch
    # libevents' ReceiveProtocol::Callbacks::send_request_event_message grew
    # a target_system_id parameter (to support wide, >255 system IDs via
    # MAVLink's extended header) since QGC v5.0.2's release; update the one
    # callback that implements it to match, using the wide-target-aware
    # pack_chan function libevents' own doc comment says to use.
    ./libevents-wide-target-system.patch
    # mavlink's (unstable, "development"-dialect) CONTROL_STATUS message had
    # its sysid_in_control field renamed to gcs_main (plus new flags/
    # gcs_secondary fields) since QGC v5.0.2's release. development-dialect
    # messages are explicitly unstable upstream (see src/MAVLink/
    # CMakeLists.txt's own comment); not Nix-specific.
    ./mavlink-control-status-field-rename.patch
    # Same QString::arg() overload-resolution issue as
    # qflags-arg-overload.patch, here for a QByteArray-indexed char (newer
    # Qt6 is stricter about implicit char->integer promotion in arg()'s
    # overload set). TODO: Upstream.
    ./qbytearray-char-arg-overload.patch
    # cmake/Install.cmake unconditionally does two things any plain `cmake
    # --install .` on Linux would also hit, not just ours: (1) Qt's own QML
    # deploy script tries to vendor-copy Qt's QML plugins into the install
    # prefix and RPATH-patch them in place, which fails (and is pointless -
    # Qt is already in the store and wrapQtAppsHook already wires up
    # QML/plugin search paths); (2) the Linux branch unconditionally tries
    # to build an AppImage, file(DOWNLOAD)'ing x86_64-only prebuilt tools.
    # We don't want an AppImage anyway - nix distributes via the store, not
    # bundled binaries. Keep the desktop/icon/metainfo install() rules,
    # which are legitimate and correct.
    ./no-appimage-in-install.patch
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
    git # Needed for cmake/Git.cmake's version-string generation
  ]
  ++ (with qt6; [
    qttools
    wrapQtAppsHook
  ]);

  propagatedBuildInputs = with qt6; [
    qtbase
    qtcharts
    qtconnectivity
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
    # Override maximum version to always accept the packaged qt6
    (lib.cmakeFeature "QGC_QT_MAXIMUM_VERSION" qt6.qtbase.version)
    # Qt's AUTOGEN machinery tries to add_dependencies() on every directly
    # linked library for its timestamp-tracking target, which fails for any
    # of them that's a plain IMPORTED target (as find_package Config-mode
    # targets are, e.g. GeographicLib::GeographicLib) since those have no
    # build step to depend on. AUTOGEN doesn't need this to work correctly.
    (lib.cmakeBool "CMAKE_AUTOGEN_ORIGIN_DEPENDS" false)
    # See no-git-info-crash.patch: there's no .git directory in our source,
    # so tell cmake/Git.cmake the real version instead of just falling back
    # to "0.0.0".
    (lib.cmakeFeature "QGC_APP_VERSION" finalAttrs.version)
    (lib.cmakeFeature "QGC_APP_VERSION_STR" "v${finalAttrs.version}")
    # src/QtLocationPlugin genuinely links Qt6::LocationPrivate (see
    # find-qt-location-private.patch); this just silences Qt's standard
    # "you're using private APIs, don't expect ABI stability" caution for
    # that, which is already a known/accepted tradeoff upstream, not
    # something to fix.
    (lib.cmakeBool "QT_NO_PRIVATE_MODULE_WARNING" true)
  ];

  # The desktop file, AppStream metainfo and icon are installed by QGC's own
  # cmake/Install.cmake (see no-appimage-in-install.patch); no custom
  # installPhase needed. CMAKE_INSTALL_PREFIX is already $out via the
  # standard cmake setup hook.
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
