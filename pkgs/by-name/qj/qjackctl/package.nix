{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  alsa-lib,
  libjack2,
  dbus,
  libsForQt5,
  # Enable jack session support
  jackSession ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.9.91";
  pname = "qjackctl";

  # some dependencies such as killall have to be installed additionally

  src = fetchFromGitHub {
    owner = "rncbc";
    repo = "qjackctl";
    tag = "qjackctl_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-YfdRyylU/ktFvsh18FjpnG9MkV1HxHJBhRnHWQ7I+hY=";
  };

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtx11extras
    libsForQt5.qttools
    alsa-lib
    libjack2
    dbus
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DCONFIG_JACK_VERSION=1"
    "-DCONFIG_JACK_SESSION=${toString jackSession}"
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
