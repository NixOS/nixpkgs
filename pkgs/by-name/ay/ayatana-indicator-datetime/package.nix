{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  nixosTests,
  ayatana-indicator-messages,
  cmake,
  dbus,
  dbus-test-runner,
  evolution-data-server,
  glib,
  gst_all_1,
  gtest,
  intltool,
  libaccounts-glib,
  libayatana-common,
  libical,
  libnotify,
  libuuid,
  lomiri,
  pkg-config,
  properties-cpp,
  python3,
  systemd,
  tzdata,
  wrapGAppsHook3,
  # Generated a different indicator
  enableLomiriFeatures ? false,
}:

let
  edsDataDir = "${evolution-data-server}/share";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ayatana-indicator-datetime";
  version = "25.4.0";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "ayatana-indicator-datetime";
    tag = finalAttrs.version;
    hash = "sha256-8E9ucy8I0w9DDzsLtzJgICz/e0TNqOHgls9LrgA5nk4=";
  };

  postPatch = ''
    # Override systemd prefix
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})' \
      --replace-fail 'XDG_AUTOSTART_DIR "/etc' 'XDG_AUTOSTART_DIR "''${CMAKE_INSTALL_FULL_SYSCONFDIR}'

    # Looking for Lomiri schemas for code generation
    substituteInPlace src/CMakeLists.txt \
      --replace-fail '/usr/share/accountsservice' '${lomiri.lomiri-schemas}/share/accountsservice'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    glib # for schema hook
    intltool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs =
    [
      ayatana-indicator-messages
      evolution-data-server
      glib
      libaccounts-glib
      libayatana-common
      libical
      libnotify
      libuuid
      properties-cpp
      systemd
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
    ])
    ++ (with lomiri; [
      cmake-extras
    ])
    ++ lib.optionals enableLomiriFeatures (with lomiri; [
      lomiri-schemas
      lomiri-sounds
      lomiri-url-dispatcher
    ]);

  nativeCheckInputs = [
    dbus
    dbus-test-runner
    (python3.withPackages (ps: with ps; [ python-dbusmock ]))
    tzdata
  ];

  checkInputs = [
    dbus-test-runner
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
    (lib.cmakeBool "ENABLE_LOMIRI_FEATURES" enableLomiriFeatures)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  enableParallelChecking = false;

  preCheck = ''
    export XDG_DATA_DIRS=${
      lib.strings.concatStringsSep ":" [
        # org.ayatana.common schema
        (glib.passthru.getSchemaDataDirPath libayatana-common)

        # loading EDS engines to handle ICS-loading
        edsDataDir
      ]
    }
  '';

  # schema is already added automatically by wrapper, EDS needs to be added explicitly
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${edsDataDir}"
    )
  '';

  passthru = {
    ayatana-indicators = {
      ayatana-indicator-datetime = [
        "ayatana"
        "lomiri"
      ];
    };
    tests = {
      startup = nixosTests.ayatana-indicators;
      lomiri = nixosTests.lomiri.desktop-ayatana-indicator-datetime;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Ayatana Indicator providing clock and calendar";
    longDescription = ''
      This Ayatana Indicator provides a combined calendar, clock, alarm and
      event management tool.
    '';
    homepage = "https://github.com/AyatanaIndicators/ayatana-indicator-datetime";
    changelog = "https://github.com/AyatanaIndicators/ayatana-indicator-datetime/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.linux;
  };
})
