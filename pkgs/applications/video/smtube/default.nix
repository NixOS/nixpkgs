{ lib, mkDerivation, fetchurl, qmake, qtscript, qtwebkit }:

mkDerivation rec {
  version = "21.7.0";
  pname = "smtube";

  src = fetchurl {
    url = "mirror://sourceforge/smtube/SMTube/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-d+R3eM2BPdrsY7XX+6IWpz6cKIy/L2x0iLZH0mTgfcc=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  dontUseQmakeConfigure = true;

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtscript qtwebkit ];

  meta = with lib; {
    description = "Play and download Youtube videos";
    homepage = "http://smplayer.sourceforge.net/smtube.php";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.linux;
  };
}
