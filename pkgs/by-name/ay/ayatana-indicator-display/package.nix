{
  stdenv,
  lib,
  gitUpdater,
  fetchFromGitHub,
  nixosTests,
  accountsservice,
  cmake,
  cppcheck,
  dbus,
  geoclue2,
  glib,
  gsettings-desktop-schemas,
  gtest,
  intltool,
  libayatana-common,
  libgudev,
  libqtdbusmock,
  libqtdbustest,
  librda,
  libsForQt5,
  lomiri,
  mate,
  pkg-config,
  properties-cpp,
  python3,
  systemd,
  wrapGAppsHook3,
  xsct,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ayatana-indicator-display";
  version = "24.5.2";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "ayatana-indicator-display";
    tag = finalAttrs.version;
    hash = "sha256-rsZjEfAiz1HC5XMjPume1Y6miNAv1kmPFP4J/+NKlsA=";
  };

  postPatch = ''
    # Replace systemd prefix in pkg-config query, use GNUInstallDirs location for /etc
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})' \
      --replace-fail 'DESTINATION "/etc' 'DESTINATION "''${CMAKE_INSTALL_FULL_SYSCONFDIR}'

    # Hardcode xsct path
    substituteInPlace src/service.cpp \
      --replace-fail 'sCommand = g_strdup_printf ("xsct' 'sCommand = g_strdup_printf ("${lib.getExe xsct}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    glib # for schema discovery
    intltool
    pkg-config
    wrapGAppsHook3
  ];

  # TODO Can we get around requiring every desktop's schemas just to avoid segfaulting on some systems?
  buildInputs = [
    accountsservice
    geoclue2
    gsettings-desktop-schemas # gnome schemas
    glib
    libayatana-common
    libgudev
    librda
    libsForQt5.qtbase
    systemd
  ]
  ++ (with lomiri; [
    cmake-extras
    lomiri-schemas # lomiri schema
  ])
  ++ (with mate; [
    mate.marco # marco schema
    mate.mate-settings-daemon # mate mouse schema
  ]);

  nativeCheckInputs = [
    cppcheck
    dbus
    (python3.withPackages (ps: with ps; [ python-dbusmock ]))
  ];

  checkInputs = [
    gtest
    libqtdbusmock
    libqtdbustest
    properties-cpp
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ENABLE_COLOR_TEMP" true)
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    ayatana-indicators = {
      ayatana-indicator-display = [
        "ayatana"
        "lomiri"
      ];
    };
    tests = {
      startup = nixosTests.ayatana-indicators;
      lomiri = nixosTests.lomiri.desktop-ayatana-indicator-display;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Ayatana Indicator for Display configuration";
    longDescription = ''
      This Ayatana Indicator is designed to be placed on the right side of a
      panel and give the user easy control for changing their display settings.
    '';
    homepage = "https://github.com/AyatanaIndicators/ayatana-indicator-display";
    changelog = "https://github.com/AyatanaIndicators/ayatana-indicator-display/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.linux;
  };
})
