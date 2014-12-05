{stdenv, fetchurl, qt4}:

stdenv.mkDerivation {
  name = "smtube-14.8.0";
  src = fetchurl {
    url = mirror://sourceforge/smplayer/smtube-14.8.0.tar.bz2;
    sha256 = "0h0kw4dvdj9sbxp0p6bdib9y8i7854f45lsmrdkykzk6rmgrf1cw";
  };

  buildInputs = [qt4];

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
