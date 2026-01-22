{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  alsa-lib,
  libjack2,
  dbus,
  qt6,
  # Enable jack session support
  jackSession ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.0.4";
  pname = "qjackctl";

  src = fetchFromGitHub {
    owner = "rncbc";
    repo = "qjackctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eZ3PBacRdMJCHHwE0qYi4jgSb7G7uS2Q+j02EdnSYqA=";
  };

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    alsa-lib
    libjack2
    dbus
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CONFIG_JACK_VERSION" "1")
    (lib.cmakeFeature "CONFIG_JACK_SESSION" (toString jackSession))
  ];

  meta = {
    description = "Qt application to control the JACK sound server daemon";
    mainProgram = "qjackctl";
    homepage = "https://github.com/rncbc/qjackctl";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
