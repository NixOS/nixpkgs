{
  lib,
  stdenv,
  fetchurl,
  cmake,
  doxygen,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "imaginepp";
  version = "6.0.0";

  src = fetchurl {
    url = "https://imagine.enpc.fr/~monasse/Imagine++/downloads/ImaginePP-${version}-Source.tar.gz";
    hash = "sha256-EYcvDNi9SJQgYmql4mXK2uMBegZ8XP3UKMKcLBLleKY=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  postBuild = ''
    (cd Doc; doxygen)
  '';

  meta = {
    description = "Set of libraries developed at the Imagine group (http://imagine.enpc.fr)";
    homepage = "https://imagine.enpc.fr/~monasse/Imagine++/";
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
