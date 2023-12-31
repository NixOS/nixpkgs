{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, gitUpdater
, nixosTests
, ayatana-indicator-messages
, cmake
, dbus
, dbus-test-runner
, evolution-data-server
, glib
, gst_all_1
, gtest
, intltool
, libaccounts-glib
, libayatana-common
, libical
, libnotify
, libuuid
, lomiri
, pkg-config
, properties-cpp
, python3
, systemd
, tzdata
, wrapGAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ayatana-indicator-datetime";
  version = "23.10.1";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "ayatana-indicator-datetime";
    # Release wasn't tagged?
    # https://github.com/AyatanaIndicators/ayatana-indicator-datetime/issues/121
    rev = "d8debd706fe92de09e5c654c4ea2cc5dd5ce0529";
    hash = "sha256-cm1zhG9TODGe79n/fGuyVnWL/sjxUc3ZCu9FhqA1NLE=";
  };

  patches = [
    # Fix test-menus building & running
    # Remove when https://github.com/AyatanaIndicators/ayatana-indicator-datetime/pull/122 merged & in release
    (fetchpatch {
      name = "0001-ayatana-indicator-datetime-tests-test-menu-Fix-build.patch";
      url = "https://github.com/AyatanaIndicators/ayatana-indicator-datetime/commit/a6527e90d855d43f43e1ff9bccda2fa22d3c60ab.patch";
      hash = "sha256-RZY51UnrMcXbZbwyuCHSxY6toGByaObSEntVnIMz7+w=";
    })
    (fetchpatch {
      name = "0002-ayatana-indicator-datetime-tests-Fix-show_alarms-tests.patch";
      url = "https://github.com/AyatanaIndicators/ayatana-indicator-datetime/commit/5186b51c004ec25e8a44fe5918bceb3d45abb108.patch";
      hash = "sha256-goVcpN0MNOic8mpdJdhjgS9LHQLVEZT6ZEg1PqLvmsE=";
    })
  ];

  postPatch = ''
    # Queries systemd user unit dir via pkg_get_variable, can't override prefix
    substituteInPlace data/CMakeLists.txt \
      --replace 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'set(SYSTEMD_USER_DIR ''${CMAKE_INSTALL_PREFIX}/lib/systemd/user)' \
      --replace '/etc' "\''${CMAKE_INSTALL_SYSCONFDIR}"

    # Looking for Lomiri schemas for code generation
    substituteInPlace src/CMakeLists.txt \
      --replace '/usr/share/accountsservice' '${lomiri.lomiri-schemas}/share/accountsservice'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    glib # for schema hook
    intltool
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
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
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ]) ++ (with lomiri; [
    cmake-extras
    lomiri-schemas
    lomiri-sounds
    lomiri-url-dispatcher
  ]);

  nativeCheckInputs = [
    dbus
    (python3.withPackages (ps: with ps; [
      python-dbusmock
    ]))
    tzdata
  ];

  checkInputs = [
    dbus-test-runner
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
    (lib.cmakeBool "ENABLE_LOMIRI_FEATURES" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (lib.concatStringsSep ";" [
      # Exclude tests
      "-E" (lib.strings.escapeShellArg "(${lib.concatStringsSep "|" [
        # evolution-data-server tests have been silently failing on upstream CI for awhile,
        # 23.10.0 release has fixed the silentness but left the tests broken.
        # https://github.com/AyatanaIndicators/ayatana-indicator-datetime/commit/3e65062b5bb0957b5bb683ff04cb658d9d530477
        "^test-eds-ics"
      ]})")
    ]))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  enableParallelChecking = false;

  preCheck = ''
    export XDG_DATA_DIRS=${glib.passthru.getSchemaDataDirPath libayatana-common}
  '';

  passthru = {
    ayatana-indicators = [
      "ayatana-indicator-datetime"
    ];
    tests = {
      inherit (nixosTests) ayatana-indicators;
    };
    # Latest release wasn't tagged, Don't try to bump down
    #updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Ayatana Indicator providing clock and calendar";
    longDescription = ''
      This Ayatana Indicator provides a combined calendar, clock, alarm and
      event management tool.
    '';
    homepage = "https://github.com/AyatanaIndicators/ayatana-indicator-datetime";
    # Latest release wasn't tagged
    # changelog = "https://github.com/AyatanaIndicators/ayatana-indicator-datetime/blob/${finalAttrs.version}/ChangeLog";
    changelog = "https://github.com/AyatanaIndicators/ayatana-indicator-datetime/blob/${finalAttrs.finalPackage.src.rev}/ChangeLog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
})
