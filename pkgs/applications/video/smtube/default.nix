{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "smtube-14.12.0";
  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "1q3gh0yv1lz63prllrjqzkj15x84lcxl2bwpy96iq5n89lf6i2kw";
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
