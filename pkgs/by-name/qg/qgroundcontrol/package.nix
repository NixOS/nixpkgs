{
  lib,
  stdenv,
  fetchFromGitHub,
  ardupilot-parameters,
  cmake,
  cpm-cmake,
  earcut-hpp,
  expat,
  geographiclib,
  git,
  libarchive,
  libevents,
  libexif,
  libosmium,
  mavlink-c-library-v2,
  protozero,
  sdl3,
  sdl_gamecontrollerdb,
  shapelib,
  ulog-cpp,
  valijson,
  xz,
  xz-embedded,
  zlib,
  zstd,
  ninja,
  gst_all_1,
  wayland,
  pkg-config,
  nix-update-script,
  px4-gpsdrivers,
  python3,
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
    # Guards the /etc/group permission check (which false-positives under
    # Nix, where there's no stable notion of "the user is in the dialout
    # group" the way a normal distro install has) behind a macro this patch
    # introduces; QGC_DISABLE_ETC_GROUP_CHECKS below actually defines it.
    ./disable-etc-group-check.patch
    # Each of these replaces a CPMAddPackage call (which vendors+recompiles a
    # dependency's sources at build time, requiring network access) with the
    # real nixpkgs package, found via find_package.
    # Also drops QGC's own vendored sensor_gps_s/satellite_info_s/
    # sensor_gnss_relative_s headers (which floated to whatever px4-gpsdrivers
    # commit was HEAD at some past CI run) in favor of px4-gpsdrivers' real
    # installed ones, and updates every place that used the old
    # sensor_gps_s/latitude_deg-style field names px4-gpsdrivers has since
    # renamed to sensor_gnss_s/latitude (see px4-gpsdrivers' own
    # build-overhaul.patch). Since those headers carry no Qt dependency of
    # their own, the Q_DECLARE_METATYPE calls QGC's old local copies carried
    # now live in GPSDriver.h, the one header shared by every file that
    # passes these types across a Qt signal/slot.
    ./use-px4-gpsdrivers.patch
    ./use-nixpkgs-mavlink.patch
    ./use-nixpkgs-libevents.patch
    # Upstream switched Joystick's vendored SDL2 to SDL3 (and moved it to its
    # own src/Utilities/SDL/CMakeLists.txt) as of v5.1.5.
    ./use-nixpkgs-sdl3.patch
    # No use-nixpkgs-compression.patch:
    # src/Utilities/Compression/CMakeLists.txt's CPMAddPackage calls already
    # have an if(<name>_ADDED)...elseif(NOT <name>_FOUND) FATAL_ERROR...endif()
    # dual path, and (CPM_LOCAL_PACKAGES_ONLY, set by cpm-cmake's setup hook,
    # making CPMAddPackage try find_package(<NAME>) first) every one of those
    # NAMEs (ZLIB, LibLZMA, zstd, LibArchive) matches a real find_package
    # result given the buildInputs below, and cpm-cmake's own
    # forward-found-variable.patch makes that result actually visible here.
    # No patch needed.
    #
    # use-nixpkgs-geographiclib.patch is still needed despite the same dual
    # path existing in src/Utilities/Geo/CMakeLists.txt: unlike the
    # compression libs, GeographicLib's own installed *-config-version.cmake
    # rejects the match CPM's NAMES override finds (see that patch).
    ./use-nixpkgs-geographiclib.patch
    # src/Utilities/Parsing/CMakeLists.txt's libexif block is upstream's own
    # from-source vendoring (not even a CPMAddPackage - it compiles libexif's
    # sources directly with a hand-rolled config.h/_stdint.h, skipping
    # libexif's own autotools build entirely); replace with the real
    # pkg-config-discoverable nixpkgs package. Also replaces the file's
    # valijson CPMAddPackage (which exists only to apply a QtJsonAdapter
    # int64-truncation fix - see pkgs/by-name/va/valijson - to a vendored
    # copy) with find_package against the real package, now carrying the
    # same fix. ulog_cpp in the same file is a plain CPMAddPackage already
    # handled by CPM_LOCAL_PACKAGES_ONLY (its upstream CMake project name
    # matches our package's exactly) - no patch needed for it.
    ./use-nixpkgs-libexif-and-valijson.patch
    # qgc_disable_dependency_warnings() (cmake/CompilerWarnings.cmake)
    # already special-cases INTERFACE_LIBRARY targets but never checks for
    # IMPORTED ones; calling target_compile_options() with a PRIVATE/PUBLIC
    # scope on an IMPORTED target (e.g. our real ulog_cpp::ulog_cpp, found
    # via find_package instead of being CPM-built) is a hard CMake error -
    # only INTERFACE properties are settable on IMPORTED targets. This is a
    # genuine upstream gap in QGC's own helper, not something specific to
    # our packaging: fix it the same way the existing INTERFACE_LIBRARY
    # case is handled, by returning early (IMPORTED targets are prebuilt,
    # so there's nothing left to disable warnings on anyway).
    ./fix-disable-warnings-imported-targets.patch
    # Three call sites compare mavlink_message_t's sysid (uint32_t) directly
    # against Vehicle::id() (int) with -Werror=sign-compare active; a
    # genuine upstream bug independent of our packaging (not every
    # compiler/flag combination upstream tests against flags it). Cast to
    # match types instead of touching the actual comparison semantics.
    ./fix-sysid-vehicle-id-sign-compare.patch
    # Same -Werror=sign-compare issue as fix-sysid-vehicle-id-sign-compare.patch
    # above (mavlink_message_t's sysid is uint32_t, Vehicle::id()/_targetSystem
    # are int), in two spots that patch doesn't cover.
    ./fix-remoteidmanager-sign-compare.patch
    # GCC's -Warray-bounds misreads the raw-pointer indexing into
    # QByteArray::constData() here as possibly aliasing QByteArray's shared
    # empty-string buffer (a static const char[1]); QByteArray::at() is
    # bounds-checked and doesn't trip the same false positive.
    ./fix-mavlinklogmanager-array-bounds.patch
    # Same -Werror=sign-compare issue again, in Vehicle.cc and
    # VehicleFactGroup.cc.
    ./fix-vehicle-sign-compare.patch
    ./fix-vehiclefactgroup-sign-compare.patch
    # src/FirmwarePlugin/APM/CMakeLists.txt's ArduPilotParams CPMAddPackage
    # floats on ArduPilot's default branch with no pin at all (GIT_TAG
    # main) and is DOWNLOAD_ONLY - no find_package attempt, just a plain
    # data dump globbed via *_SOURCE_DIR. There's no "package" here in any
    # find_package sense (it's just per-version JSON parameter dumps, not a
    # C/C++ library), so point the *_SOURCE_DIR variable directly at our
    # own pinned, independently-updatable package instead.
    ./use-nixpkgs-ardupilot-parameters.patch
    # src/Viewer3D/Providers/Osm/CMakeLists.txt's protozero/libosmium
    # CPMAddPackages are the same shape (DOWNLOAD_ONLY, no find_package
    # attempt, neither has a CMake config of its own anyway) - point their
    # target_include_directories directly at the real nixpkgs packages.
    # EXPAT already has real dual-path support (CMake's builtin FindEXPAT
    # module matches the NAME exactly) and just needs `expat` as a
    # buildInput - no patch needed for it. earcut_hpp's CPMAddPackage does
    # need a real patch: it's EXCLUDE_FROM_ALL specifically to dodge
    # upstream's own CMakeLists.txt unconditionally defining test/bench/viz
    # helper targets regardless of the EARCUT_BUILD_* OPTIONS passed - our
    # standalone earcut-hpp package (pkgs/by-name/ea/earcut-hpp) already
    # works around that upstream quirk itself, so this just needs a plain
    # find_package swap.
    ./use-nixpkgs-osm-deps.patch
    ./use-nixpkgs-shapelib.patch
    # cmake/GStreamer/platform/Linux.cmake's own SDK discovery assumes a
    # single FHS-style root (a /usr-like prefix with one
    # lib/<triplet>/gstreamer-1.0 holding every plugin); nixpkgs splits
    # gstreamer/gst-plugins-base/gst-plugins-good/gst-plugins-bad/gst-libav
    # into separate store paths, so there is no such root to guess. Ask
    # pkg-config (already pointed at every one of those store paths via
    # PKG_CONFIG_PATH, which is how the per-component pkg_check_modules calls
    # in FindGStreamer.cmake resolve them a moment later) where the core
    # gstreamer-1.0 module itself lives, and derive the root/lib/include paths
    # QGC's own layout/orchestration bookkeeping wants from that instead.
    ./use-nixpkgs-gstreamer-root.patch
    # gstreamer_install_platform_sdk() (called unconditionally from
    # src/VideoManager/VideoReceiver/GStreamer/CMakeLists.txt) bundles the
    # discovered GStreamer's plugins into the install prefix and then
    # verifies that bundle is complete - a model built for upstream's own
    # self-contained AppImage packaging (see no-appimage-in-install.patch for
    # the same reasoning applied to cmake/Install.cmake). It assumes a single
    # plugin directory holds everything QGC needs, which use-nixpkgs-
    # gstreamer-root.patch's discovery can't give it here (see that patch);
    # skip it, since GST_PLUGIN_SYSTEM_PATH_1_0 (wired up in postInstall)
    # already makes every plugin in every gst_all_1 buildInput discoverable
    # at runtime without copying anything into $out.
    ./skip-gstreamer-sdk-install.patch
    # (As of v5.1.5, upstream has removed gstqml6gl - the vendored Qt6 GL
    # video sink plugin our old use-nixpkgs-gst-qt6-sources.patch and
    # no-static-qml6-plugin.patch dealt with - and its prePatch rm -rf,
    # entirely; there is no longer anything in this area to un-vendor.)
    # cmake/modules/Git.cmake's no-.git fallback branch unconditionally
    # set()s QGC_APP_VERSION/QGC_APP_VERSION_STR, which (since this file is
    # include()d into the top-level scope) shadows our QGC_APP_VERSION/
    # QGC_APP_VERSION_STR cmakeFlags cache variables with "0.0.0"/"v0.0.0"
    # for the rest of configure. Let a pre-set cache variable win instead.
    ./no-git-info-crash.patch
    # find-qt-location-private.patch no longer needed: upstream's top-level
    # find_package(Qt6 COMPONENTS ...) list already includes LocationPrivate
    # as of v5.1.5 (the oversight it worked around is fixed upstream now).
    # 3 files (of the original 5; upstream has since added the include to
    # QGCTileCacheWorker.h and dropped the QElapsedTimer use from
    # GstVideoReceiver.cc entirely) use QElapsedTimer without including it
    # directly (it happens to come in transitively through some other Qt
    # header on the Qt version upstream's CI uses, but not reliably - a real
    # upstream bug, not Nix-specific). TODO: Upstream.
    ./missing-qelapsedtimer-includes.patch
    # missing-unistd-include.patch no longer needed: the getuid() call moved
    # out of main.cc entirely (into Platform::isRunningAsRoot(), now in
    # src/Utilities/Platform/Platform.cc), which already guards its own
    # <unistd.h> include behind Q_OS_LINUX/Q_OS_FREEBSD.
    # qflags-arg-overload.patch no longer needed: upstream's
    # ADSBVehicle::update() already calls .toInt() on the QFlags value
    # passed to QString::arg() now (same fix our patch used to apply).
    # libevents' ReceiveProtocol::Callbacks::send_request_event_message grew
    # a target_system_id parameter (to support wide, >255 system IDs via
    # MAVLink's extended header) since QGC v5.0.2's release; update the one
    # callback that implements it to match (now in MAVLinkEventManager.cc,
    # moved there from Vehicle.cc since v5.0.2), using the wide-target-aware
    # pack_chan function libevents' own doc comment says to use.
    ./libevents-wide-target-system.patch
    # mavlink-control-status-field-rename.patch no longer needed: QGC's own
    # Vehicle::_handleControlStatus() has since been refactored upstream to
    # use controlStatus.gcs_main (and a _gcsMain member) throughout, matching
    # the pinned mavlink-c-library-v2's CONTROL_STATUS definition already -
    # no sysid_in_control reference remains.
    # qbytearray-char-arg-overload.patch no longer needed: upstream's
    # Bootloader::_burnMulti() compare-mismatch error string already casts
    # the QByteArray-indexed char through quint8/qulonglong before handing
    # it to QString::arg() now (a more thorough version of our old cast).
    # cmake/install/Install.cmake (moved from cmake/Install.cmake) still
    # unconditionally runs Qt's own QML deploy script on every platform
    # including Linux: it tries to vendor-copy Qt's QML plugins into the
    # install prefix and RPATH-patch them in place, which fails (and is
    # pointless - Qt is already in the store and wrapQtAppsHook already
    # wires up QML/plugin search paths). Guard it off on Linux. The
    # AppImage-building step itself (now its own cmake/install/
    # CreateAppImage.cmake, file(DOWNLOAD)'ing x86_64-only prebuilt tools)
    # no longer needs patching out: it only runs when QGC_CREATE_APPIMAGE is
    # true (see cmakeFlags below), so we just turn that off instead. The
    # desktop/icon/metainfo install() rules are unconditional and untouched
    # by either of these, and are legitimate and correct.
    ./no-appimage-in-install.patch
  ];

  # Unvendor CPM. cpm-cmake's setup hook sets CPM_LOCAL_PACKAGES_ONLY, which
  # makes every remaining (unpatched) CPMAddPackage call resolve via
  # find_package against the real nixpkgs packages below instead of
  # attempting a network fetch (e.g. ulog_cpp, whose upstream CMake project
  # name happens to already match what find_package needs).
  # message_definitions/v1.0 and component_metadata are mavgen-input XML/JSON
  # data from the mavlink/mavlink *source* repo (not part of any C library a
  # find_package could discover, and not shipped by our mavlink-c-library-v2
  # package, which only installs generated .h files); fetch just those
  # straight from Nix at the same commit QGC's own CMakeLists.txt pins
  # (QGC_MAVLINK_GIT_TAG), instead of letting CPM fetch the whole repo over
  # the network at build time. See use-nixpkgs-mavlink.patch.
  mavlinkMetadataSrc = fetchFromGitHub {
    owner = "mavlink";
    repo = "mavlink";
    rev = "c409cf690454db6d3e004bd14173bc6c7ff1e0ff";
    hash = "sha256-lT+fI0JuyYbSivZE7oKdtUVh2cKXiwiEgyTpG/qSSsE=";
  };

  postPatch = ''
    rm cmake/modules/CPM.cmake
    ln -s ${cpm-cmake}/share/cpm/CPM.cmake cmake/modules/CPM.cmake

    substituteInPlace src/Utilities/SDL/CMakeLists.txt \
      --replace-fail '@SDL_GAMECONTROLLERDB_FILE@' "${sdl_gamecontrollerdb}/share/gamecontrollerdb.txt"

    substituteInPlace src/MAVLink/LibEvents/CMakeLists.txt \
      --replace-fail '@LIBEVENTS_INCLUDE_DIR@' "${libevents}/include"

    substituteInPlace src/MAVLink/CMakeLists.txt \
      --replace-fail '@MAVLINK_C_LIBRARY_INCLUDE_DIR@' "${mavlink-c-library-v2}/include/mavlink-c-library-v2" \
      --replace-fail '@MAVLINK_XML_DIR@' "${finalAttrs.mavlinkMetadataSrc}/message_definitions/v1.0" \
      --replace-fail '@MAVLINK_COMPONENT_METADATA_DIR@' "${finalAttrs.mavlinkMetadataSrc}/component_metadata"

    substituteInPlace src/FirmwarePlugin/APM/CMakeLists.txt \
      --replace-fail '@ARDUPILOT_PARAMETERS_DIR@' "${ardupilot-parameters}/share/ardupilot-parameters"

    substituteInPlace src/Viewer3D/Providers/Osm/CMakeLists.txt \
      --replace-fail '@PROTOZERO_INCLUDE_DIR@' "${protozero}/include" \
      --replace-fail '@LIBOSMIUM_INCLUDE_DIR@' "${libosmium}/include"
  '';

  nativeBuildInputs = [
    cmake
    cpm-cmake
    ninja
    pkg-config
    git # Needed for cmake/modules/Git.cmake's version-string generation
    # cmake/modules/PythonVenv.cmake wants to pip-install its own venv for
    # the mavlink/mavgen-adjacent generator scripts (see QGC_AUTO_PYTHON_VENV
    # below); network access is unavailable in the sandbox, so give it a
    # "system python" that already has everything tools/pyproject.toml's
    # "scripts" dependency group would otherwise have pip-installed.
    (python3.withPackages (ps: [
      ps.defusedxml
      ps.httpx
      ps.jinja2
    ]))
  ]
  ++ (with qt6; [
    qttools
    wrapQtAppsHook
  ]);

  propagatedBuildInputs = with qt6; [
    qtbase
    qtcharts
    qtconnectivity
    qtdeclarative
    qtgraphs
    qthttpserver
    qtlocation
    qtmultimedia
    qtpositioning
    qtquick3d
    qtscxml
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
    sdl3
    earcut-hpp
    expat
    geographiclib
    libarchive
    libevents
    libexif
    mavlink-c-library-v2
    shapelib
    ulog-cpp
    valijson
    px4-gpsdrivers
    xz
    xz-embedded
    zlib
    zstd
  ]
  ++ finalAttrs.gstInputs
  ++ finalAttrs.propagatedBuildInputs;

  cmakeFlags = [
    # cmake/modules/PythonVenv.cmake defaults to bootstrapping its own
    # pip-managed .venv (network access, unavailable in the sandbox); our
    # "system python" nativeBuildInput above already has everything that
    # venv would otherwise provide, so skip the bootstrap attempt entirely.
    (lib.cmakeBool "QGC_AUTO_PYTHON_VENV" false)
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
    # src/QtLocationPlugin genuinely links Qt6::LocationPrivate; this just
    # silences Qt's standard "you're using private APIs, don't expect ABI
    # stability" caution for that, which is already a known/accepted
    # tradeoff upstream, not something to fix. (Upstream's own CMakeLists.txt
    # already sets this too; kept explicit here in case that ever changes.)
    (lib.cmakeBool "QT_NO_PRIVATE_MODULE_WARNING" true)
    # See skip-gstreamer-sdk-install.patch: don't bundle/verify a GStreamer
    # SDK copy in $out; GST_PLUGIN_SYSTEM_PATH_1_0 (postInstall) is the real
    # runtime discovery mechanism for every gst_all_1 buildInput.
    (lib.cmakeBool "QGC_GST_SKIP_SDK_INSTALL" true)
    # Default ON upstream: cmake/install/Install.cmake's Linux branch builds
    # an AppImage via cmake/install/CreateAppImage.cmake, which
    # file(DOWNLOAD)'s x86_64-only prebuilt linuxdeploy/appimagetool
    # binaries. We don't want an AppImage anyway - nix distributes via the
    # store, not bundled binaries - and this option is the clean way to
    # skip it (no patch needed; see no-appimage-in-install.patch for the
    # one thing in that file that does still need patching).
    (lib.cmakeBool "QGC_CREATE_APPIMAGE" false)
    # See disable-etc-group-check.patch: that patch adds the real
    # option()/target_compile_definitions() plumbing for this, matching how
    # upstream's own QGC_NO_SERIAL_LINK etc. are wired, rather than reaching
    # for a blunt global CMAKE_CXX_FLAGS override.
    (lib.cmakeBool "QGC_DISABLE_ETC_GROUP_CHECKS" true)
  ];

  # The desktop file, AppStream metainfo and icon are installed
  # unconditionally by QGC's own cmake/install/Install.cmake (see
  # no-appimage-in-install.patch); no custom
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
