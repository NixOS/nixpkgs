{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "smtube-15.5.10";

  src = fetchurl {
    url = "mirror://sourceforge/smplayer/${name}.tar.bz2";
    sha256 = "1if2b0h6snfmj5hnx4cs55zjbdvwagx95jv62f2jgh3m5gis0cbz";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  buildInputs = [ qt4 ];

  meta = with stdenv.lib; {
    description = "Play and download Youtube videos";
    homepage = http://smplayer.sourceforge.net/smtube.php;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.linux;
  };
}
