{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  testers,
  cmake,
  glib,
  gobject-introspection,
  gtest,
  intltool,
  lomiri,
  pkg-config,
  systemd,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libayatana-common";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "libayatana-common";
    tag = finalAttrs.version;
    hash = "sha256-o5datBxGaGnvNvz8hvPY14DvjiFJdB7k93MumXuol0I=";
  };

  postPatch = ''
    # Queries via pkg_get_variable, can't override prefix
    substituteInPlace data/CMakeLists.txt \
      --replace 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemd_user_unit_dir)' 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemd_user_unit_dir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gobject-introspection
    intltool
    pkg-config
    vala
  ];

  buildInputs = [
    lomiri.cmake-extras
    glib
    lomiri.lomiri-url-dispatcher
    systemd
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ENABLE_LOMIRI_FEATURES" true)
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Common functions for Ayatana System Indicators";
    homepage = "https://github.com/AyatanaIndicators/libayatana-common";
    changelog = "https://github.com/AyatanaIndicators/libayatana-common/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "libayatana-common"
    ];
  };
})
