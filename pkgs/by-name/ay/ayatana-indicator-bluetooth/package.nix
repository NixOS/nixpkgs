{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  nixosTests,
  cmake,
  gettext,
  glib,
  gobject-introspection,
  intltool,
  libayatana-common,
  lomiri,
  pkg-config,
  systemd,
  vala,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ayatana-indicator-bluetooth";
  version = "24.5.0";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "ayatana-indicator-bluetooth";
    tag = finalAttrs.version;
    hash = "sha256-EreOhrlWbSZtwazsvwWsPji2iLfQxr2LbjCI13Hrb28=";
  };

  postPatch = ''
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})' \
      --replace-fail '/etc' "\''${CMAKE_INSTALL_SYSCONFDIR}"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    gobject-introspection
    intltool
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    lomiri.cmake-extras
    glib
    libayatana-common
    systemd
  ];

  cmakeFlags = [
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
  ];

  passthru = {
    ayatana-indicators = {
      ayatana-indicator-bluetooth = [
        "ayatana"
        "lomiri"
      ];
    };
    tests = {
      startup = nixosTests.ayatana-indicators;
      lomiri = nixosTests.lomiri.desktop-ayatana-indicator-bluetooth;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Ayatana System Indicator for Bluetooth Management";
    longDescription = ''
      This Ayatana Indicator exposes bluetooth functionality via the system
      indicator API and provides fast user controls for Bluetooth devices.
    '';
    homepage = "https://github.com/AyatanaIndicators/ayatana-indicator-bluetooth";
    changelog = "https://github.com/AyatanaIndicators/ayatana-indicator-bluetooth/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.linux;
  };
})
