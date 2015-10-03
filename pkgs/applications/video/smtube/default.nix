{ stdenv, fetchurl, qt5 }:

stdenv.mkDerivation rec {
  version = "15.9.0";
  name = "smtube-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/smtube/SMTube/${version}/${name}.tar.bz2";
    sha256 = "1mr7iz5c2sy0yikdwybchcvgm6scs75p4cwkcpnwy2hw9p28mk1f";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  buildInputs = [ qt5.script ];

  meta = with stdenv.lib; {
    description = "Play and download Youtube videos";
    homepage = http://smplayer.sourceforge.net/smtube.php;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.linux;
  };
}
