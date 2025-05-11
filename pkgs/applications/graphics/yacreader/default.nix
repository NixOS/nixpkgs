{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  poppler,
  pkg-config,
  libunarr,
  libGLU,
}:

stdenv.mkDerivation rec {
  pname = "yacreader";
  version = "9.15.0";

  src = fetchFromGitHub {
    owner = "YACReader";
    repo = pname;
    rev = version;
    sha256 = "sha256-5vCjr8WRwa7Q/84Itgg07K1CJKGnWA1z53et2IxxReE=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    poppler
    libunarr
    libGLU
    libsForQt5.qtmultimedia
    libsForQt5.qtscript
  ];
  propagatedBuildInputs = [
    libsForQt5.qtquickcontrols2
    libsForQt5.qtgraphicaleffects
    libsForQt5.qtdeclarative
  ];

  meta = {
    description = "Comic reader for cross-platform reading and managing your digital comic collection";
    homepage = "http://www.yacreader.com";
    license = lib.licenses.gpl3;
    mainProgram = "YACReader";
    maintainers = [ ];
  };
}
