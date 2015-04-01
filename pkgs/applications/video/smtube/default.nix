{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "smtube-15.1.0";
  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "0l87afj1fwhq8lnhv0djqdc8fy0kvs4q4jrvyiz46ifq7q10qyaf";
  };

  buildInputs = [ qt4 ];

  preConfigure = ''
    makeFlags="PREFIX=$out"
  '';

  meta = with stdenv.lib; {
    description = "Play and download Youtube videos";
    homepage = http://smplayer.sourceforge.net/smtube.php;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.linux;
  };
}
