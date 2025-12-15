{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  libsForQt5,
  libjack2,
}:
stdenv.mkDerivation rec {
  pname = "jamulus";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "jamulussoftware";
    repo = "jamulus";
    tag = "r${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-YxXSSVm3n96YzE51cXpWf4z2nQBSguvcEp/kU0a6iBA=";
  };

  nativeBuildInputs = [
    pkg-config
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtscript
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
    libsForQt5.qtdeclarative
    libjack2
  ];

  qmakeFlags = [ "CONFIG+=noupcasename" ];

  meta = {
    description = "Enables musicians to perform real-time jam sessions over the internet";
    longDescription = "You also need to enable JACK and should enable several real-time optimizations. See project website for details";
    homepage = "https://github.com/corrados/jamulus";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "jamulus";
    maintainers = with lib.maintainers; [ seb314 ];
  };
}
