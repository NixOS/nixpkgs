{ lib, mkDerivation, fetchurl, qmake, qtscript, qtwebkit }:

mkDerivation rec {
  version = "20.1.0";
  pname = "smtube";

  src = fetchurl {
    url = "mirror://sourceforge/smtube/SMTube/${version}/${pname}-${version}.tar.bz2";
    sha256 = "00x7gyk06d01hrr1lcqbrffbkkpj2j0j1fy9mkxc7slbzqcl27dz";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  dontUseQmakeConfigure = true;

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtscript qtwebkit ];

  meta = with lib; {
    description = "Play and download Youtube videos";
    homepage = http://smplayer.sourceforge.net/smtube.php;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.linux;
  };
}
