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

let
  edsDataDir = "${evolution-data-server}/share";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ayatana-indicator-datetime";
  version = "23.10.1";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "ayatana-indicator-datetime";
    rev = finalAttrs.version;
    hash = "sha256-cm1zhG9TODGe79n/fGuyVnWL/sjxUc3ZCu9FhqA1NLE=";
  };

  patches = [
    # Fix test-menus building & running
    # Remove when version > 23.10.1
    (fetchpatch {
      name = "0001-ayatana-indicator-datetime-Fix-test-menus-tests.patch";
      url = "https://github.com/AyatanaIndicators/ayatana-indicator-datetime/commit/ddabb4a61a496da14603573b700c5961a3e5b834.patch";
      hash = "sha256-vf8aVXonCoTWMuAQZG6FuklWR2IaGY4hecFtoyNCGg8=";
    })

    # Fix EDS-related tests
    # Remove when version > 23.10.1
    (fetchpatch {
      name = "0002-ayatana-indicator-datetime-Fix-EDS-colour-tests.patch";
      url = "https://github.com/AyatanaIndicators/ayatana-indicator-datetime/commit/6d67f7b458911833e72e0b4a162b1d823609d6f8.patch";
      hash = "sha256-VUdMJuma6rmsjUOeyO0W8UNKADODiM+wDVfj6aDhqgw=";
    })
  ];

  postPatch = ''
    # Queries systemd user unit dir via pkg_get_variable, can't override prefix
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'set(SYSTEMD_USER_DIR ''${CMAKE_INSTALL_PREFIX}/lib/systemd/user)' \
      --replace-fail '/etc' "\''${CMAKE_INSTALL_FULL_SYSCONFDIR}"

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
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  enableParallelChecking = false;

  preCheck = ''
    export XDG_DATA_DIRS=${lib.strings.concatStringsSep ":" [
      # org.ayatana.common schema
      (glib.passthru.getSchemaDataDirPath libayatana-common)

      # loading EDS engines to handle ICS-loading
      edsDataDir
    ]}
  '';

  preFixup = ''
    # schema is already added automatically by wrapper, EDS needs to be added explicitly
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${edsDataDir}"
    )
  '';

  passthru = {
    ayatana-indicators = [
      "ayatana-indicator-datetime"
    ];
    tests = {
      inherit (nixosTests) ayatana-indicators;
    };
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Ayatana Indicator providing clock and calendar";
    longDescription = ''
      This Ayatana Indicator provides a combined calendar, clock, alarm and
      event management tool.
    '';
    homepage = "https://github.com/AyatanaIndicators/ayatana-indicator-datetime";
    changelog = "https://github.com/AyatanaIndicators/ayatana-indicator-datetime/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
})
