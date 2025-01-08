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
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "libayatana-common";
    rev = finalAttrs.version;
    hash = "sha256-qi3xsnZjqSz3I7O+xPxDnI91qDIA0XFJ3tCQQF84vIg=";
  };

  postPatch = ''
    # Queries via pkg_get_variable, can't override prefix
    substituteInPlace data/CMakeLists.txt \
      --replace 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemd_user_unit_dir)' 'set(SYSTEMD_USER_UNIT_DIR ''${CMAKE_INSTALL_PREFIX}/lib/systemd/user)'
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
    "-DENABLE_TESTS=${lib.boolToString finalAttrs.finalPackage.doCheck}"
    "-DENABLE_LOMIRI_FEATURES=ON"
    "-DGSETTINGS_LOCALINSTALL=ON"
    "-DGSETTINGS_COMPILE=ON"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Common functions for Ayatana System Indicators";
    homepage = "https://github.com/AyatanaIndicators/libayatana-common";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
    pkgConfigModules = [
      "libayatana-common"
    ];
  };
})
