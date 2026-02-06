{
  lib,
  stdenv,
  fetchurl,
  qmake,
  wrapQtAppsHook,
  qtscript,
  qtwebkit,
}:

stdenv.mkDerivation rec {
  version = "21.10.0";
  pname = "smtube";

  src = fetchurl {
    url = "mirror://sourceforge/smtube/SMTube/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ZQIUAi/YC+zsYHVhlprZ5K6NGvT6LojmdQ1Z+WCg1lU=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  dontUseQmakeConfigure = true;

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];
  buildInputs = [
    qtscript
    qtwebkit
  ];

  meta = {
    description = "Play and download Youtube videos";
    homepage = "http://smplayer.sourceforge.net/smtube.php";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ vbgl ];
    platforms = lib.platforms.linux;
  };
}
