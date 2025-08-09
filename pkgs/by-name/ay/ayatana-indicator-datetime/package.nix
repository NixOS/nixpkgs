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
  extra-cmake-modules,
  glib,
  gst_all_1,
  gtest,
  intltool,
  libaccounts-glib,
  libayatana-common,
  libical,
  mkcal,
  libnotify,
  libsForQt5,
  libuuid,
  lomiri,
  pkg-config,
  properties-cpp,
  python3,
  systemd,
  tzdata,
  wrapGAppsHook3,
  # Generates a different indicator
  enableLomiriFeatures ? false,
}:

let
  edsDataDir = "${evolution-data-server}/share";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${if enableLomiriFeatures then "lomiri" else "ayatana"}-indicator-datetime";
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
  ''
  + lib.optionalString enableLomiriFeatures ''
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
  ]
  ++ lib.optionals enableLomiriFeatures [
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    ayatana-indicator-messages
    glib
    libaccounts-glib
    libayatana-common
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
  ++ (
    if enableLomiriFeatures then
      (
        [
          extra-cmake-modules
          mkcal
        ]
        ++ (with libsForQt5; [
          kcalendarcore
          qtbase
        ])
        ++ (with lomiri; [
          lomiri-schemas
          lomiri-sounds
          lomiri-url-dispatcher
        ])
      )
    else
      [
        evolution-data-server
        libical
      ]
  );

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

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
    (lib.cmakeBool "ENABLE_LOMIRI_FEATURES" enableLomiriFeatures)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
  ]
  ++ lib.optionals enableLomiriFeatures [
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      lib.concatStringsSep ";" [
        # Exclude tests
        "-E"
        (lib.strings.escapeShellArg "(${
          lib.concatStringsSep "|" [
            # Don't know why these fail yet
            "^test-eds-ics-repeating-events"
            "^test-eds-ics-nonrepeating-events"
            "^test-eds-ics-missing-trigger"
          ]
        })")
      ]
    ))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  enableParallelChecking = false;

  preCheck = ''
    export XDG_DATA_DIRS=${
      lib.strings.concatStringsSep ":" (
        [
          # org.ayatana.common schema
          (glib.passthru.getSchemaDataDirPath libayatana-common)
        ]
        ++ lib.optionals (!enableLomiriFeatures) [
          # loading EDS engines to handle ICS-loading
          edsDataDir
        ]
      )
    }
  '';

  preFixup = ''
    gappsWrapperArgs+=(
  ''
  + (
    if enableLomiriFeatures then
      ''
        "''${qtWrapperArgs[@]}"
      ''
    else
      # schema is already added automatically by wrapper, EDS needs to be added explicitly
      ''
        --prefix XDG_DATA_DIRS : "${edsDataDir}"
      ''
  )
  + ''
    )
  '';

  passthru = {
    ayatana-indicators = {
      "${if enableLomiriFeatures then "lomiri" else "ayatana"}-indicator-datetime" = [
        (if enableLomiriFeatures then "lomiri" else "ayatana")
      ];
    };
    tests = {
      startup = nixosTests.ayatana-indicators;
    }
    // lib.optionalAttrs enableLomiriFeatures {
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
    teams = [
      lib.teams.lomiri
    ];
    platforms = lib.platforms.linux;
  };
})
