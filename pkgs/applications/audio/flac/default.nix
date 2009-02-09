{stdenv, fetchurl, libogg}:

stdenv.mkDerivation rec {
  name = "flac-1.2.1";
  
  src = fetchurl {
    url = mirror://sourceforge/flac/flac-1.2.1.tar.gz;
    sha256 = "1pry5lgzfg57pga1zbazzdd55fkgk3v5qy4axvrbny5lrr5s8dcn";
  };

  buildInputs = [libogg];
  
  meta = {
    homepage = http://flac.sourceforge.net;
  };
}
