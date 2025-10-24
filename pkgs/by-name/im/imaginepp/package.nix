{
  lib,
  stdenv,
  fetchurl,
  cmake,
  doxygen,
  qt6,
}:

stdenv.mkDerivation {
  pname = "imaginepp";
  version = "6.0.0";

  src = fetchurl {
    url = "https://imagine.enpc.fr/~monasse/Imagine++/downloads/ImaginePP-6.0.0-Source.tar.gz";
    hash = "sha256-EYcvDNi9SJQgYmql4mXK2uMBegZ8XP3UKMKcLBLleKY=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    qt6.wrapQtAppsNoGuiHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  postBuild = ''
    (cd Doc; doxygen)
  '';

  meta = {
    description = "Imagine++ is a set of libraries developed at the Imagine group (http://imagine.enpc.fr). Initially designed for students and beginners, and though it is still easy enough for them, Imagine++ is now used daily by Imagine researchers.";
    homepage = "https://imagine.enpc.fr/~monasse/Imagine++/";
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
