{stdenv, fetchurl, libogg}:

stdenv.mkDerivation {
  name = "flac-1.1.1";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/flac-1.1.1.tar.gz;
    md5 = "c6ccddccf8ad344065698047c2fc7280" ;
  };

  buildInputs = [libogg] ;
}
