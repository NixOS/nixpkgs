{ lib, mkDerivation, fetchurl, qmake, qtscript, qtwebkit }:

mkDerivation rec {
  version = "20.6.0";
  pname = "smtube";

  src = fetchurl {
    url = "mirror://sourceforge/smtube/SMTube/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0hnza5gszwqnkc1py5g34hi4p976vpkc4h3ab0247ynqs83fpwc2";
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
