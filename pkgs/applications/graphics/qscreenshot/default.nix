<<<<<<< HEAD
{ stdenv
, lib
, fetchgit
, dos2unix
, qtbase
, qttools
, qtx11extras
, wrapQtAppsHook
, cmake }:

stdenv.mkDerivation rec {
  pname = "qscreenshot";
  version = "unstable-2021-10-18";

  src = fetchgit {
    url = "https://git.code.sf.net/p/qscreenshot/code";
    rev = "e340f06ae2f1a92a353eaa68e103d1c840adc12d";
    sha256 = "0mdiwn74vngiyazr3lq72f3jnv5zw8wyd2dw6rik6dbrvfs69jig";
  };

  preConfigure = "cd qScreenshot";

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    qtx11extras
  ];
=======
{ lib, stdenv, fetchurl, dos2unix, which, qt, Carbon }:

stdenv.mkDerivation rec {
  pname = "qscreenshot";
  version = "1.0";

  src = fetchurl {
    url = "mirror://sourceforge/qscreenshot/qscreenshot-${version}-src.tar.gz";
    sha256 = "1spj5fg2l8p5bk81xsv6hqn1kcrdiy54w19jsfb7g5i94vcb1pcx";
  };

  buildInputs = [ dos2unix which qt ]
    ++ lib.optional stdenv.isDarwin Carbon;

  # Remove carriage returns that cause /bin/sh to abort
  preConfigure = ''
    dos2unix configure
    sed -i "s|lrelease-qt4|lrelease|" src/src.pro
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Simple creation and editing of screenshots";
    homepage = "https://sourceforge.net/projects/qscreenshot/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
