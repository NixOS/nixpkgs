{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  libsForQt5,
  poppler,
  pugixml,
  libzip,
  libuuid,
  tinyxml-2,
}:

stdenv.mkDerivation rec {
  pname = "docparser";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-shZXhs9ncgm6rECvCWrLi26RO1WAc1gRowoYmeKesfk=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    poppler
    pugixml
    libzip
    libuuid
    tinyxml-2
  ];

  qmakeFlags = [ "VERSION=${version}" ];

  meta = {
    description = "Document parser library ported from document2html";
    homepage = "https://github.com/linuxdeepin/docparser";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
