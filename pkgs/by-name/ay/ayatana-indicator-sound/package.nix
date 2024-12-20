{
  stdenv,
  lib,
  gitUpdater,
  fetchFromGitHub,
  nixosTests,
  accountsservice,
  cmake,
  dbus,
  dbus-test-runner,
  glib,
  gobject-introspection,
  gtest,
  intltool,
  libayatana-common,
  libgee,
  libnotify,
  libpulseaudio,
  libqtdbusmock,
  libqtdbustest,
  libsForQt5,
  libxml2,
  lomiri,
  pkg-config,
  python3,
  systemd,
  vala,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ayatana-indicator-sound";
  version = "24.5.0";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "ayatana-indicator-sound";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-sFl1PM0vZIJVSDiq5z7w/CS3rFuq6Z09Uks4Ik239Cc=";
  };

  postPatch = ''
    # Replace systemd prefix in pkg-config query, use GNUInstallDirs location for /etc
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})' \
      --replace-fail 'DESTINATION "/etc' 'DESTINATION "''${CMAKE_INSTALL_FULL_SYSCONFDIR}'

    # Build-time Vala codegen
    substituteInPlace src/CMakeLists.txt \
      --replace-fail '/usr/share/gir-1.0/AccountsService-1.0.gir' '${lib.getDev accountsservice}/share/gir-1.0/AccountsService-1.0.gir'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gobject-introspection
    intltool
    libpulseaudio # vala files(?)
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs =
    [
      accountsservice
      glib
      gobject-introspection
      libayatana-common
      libgee
      libnotify
      libpulseaudio
      libxml2
      systemd
    ]
    ++ (with lomiri; [
      cmake-extras
      lomiri-api
      lomiri-schemas
    ]);

  nativeCheckInputs = [
    dbus
    (python3.withPackages (ps: with ps; [ python-dbusmock ]))
  ];

  checkInputs = [
    dbus-test-runner
    gtest
    libsForQt5.qtbase
    libqtdbusmock
    libqtdbustest
    lomiri.gmenuharness
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ENABLE_LOMIRI_FEATURES" true)
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
  ];

  dontWrapQtApps = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    ayatana-indicators = {
      ayatana-indicator-sound = [
        "ayatana"
        "lomiri"
      ];
    };
    tests.vm = nixosTests.ayatana-indicators;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Ayatana Indicator for managing system sound";
    longDescription = ''
      Ayatana Indicator Sound that provides easy control of the PulseAudio
      sound daemon.
    '';
    homepage = "https://github.com/AyatanaIndicators/ayatana-indicator-sound";
    changelog = "https://github.com/AyatanaIndicators/ayatana-indicator-sound/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.linux;
  };
})
