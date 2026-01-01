{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  alsa-lib,
  libjack2,
  dbus,
<<<<<<< HEAD
  qt6,
=======
  libsForQt5,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # Enable jack session support
  jackSession ? false,
}:

stdenv.mkDerivation (finalAttrs: {
<<<<<<< HEAD
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
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    alsa-lib
    libjack2
    dbus
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
<<<<<<< HEAD
    qt6.wrapQtAppsHook
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CONFIG_JACK_VERSION" "1")
    (lib.cmakeFeature "CONFIG_JACK_SESSION" (toString jackSession))
=======
    libsForQt5.wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DCONFIG_JACK_VERSION=1"
    "-DCONFIG_JACK_SESSION=${toString jackSession}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
