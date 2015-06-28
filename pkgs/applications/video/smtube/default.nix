{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  versionMajor = "15.5";
  versionMinor = "17";
  version = "${versionMajor}.${versionMinor}";
  name = "smtube-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/smtube/SMTube/${versionMajor}/${name}.tar.bz2";
    sha256 = "0jbik41nb1b7381ybzblmmsl8b7ljl6a2zpn1dcg0cccjw5mnbyg";
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
