{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "linvstmanager";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Goli4thus";
    repo = "linvstmanager";
    rev = "v${version}";
    hash = "sha256-K6eugimMy/MZgHYkg+zfF8DDqUuqqoeymxHtcFGu2Uk=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  meta = with lib; {
    description = "Graphical companion application for various bridges like LinVst, etc";
    mainProgram = "linvstmanager";
    homepage = "https://github.com/Goli4thus/linvstmanager";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.GabrielDougherty ];
  };
}
