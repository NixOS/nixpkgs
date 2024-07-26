{ stdenv
, lib
, fetchgit
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
  meta = with lib; {
    description = "Simple creation and editing of screenshots";
    mainProgram = "qScreenshot";
    homepage = "https://sourceforge.net/projects/qscreenshot/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
