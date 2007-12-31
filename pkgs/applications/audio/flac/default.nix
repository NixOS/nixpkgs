{stdenv, fetchurl, libogg}:

stdenv.mkDerivation {
  name = "flac-1.2.1";
  src = fetchurl {
    url = http://downloads.xiph.org/releases/flac/flac-1.2.1.tar.gz;
    sha256 = "1pry5lgzfg57pga1zbazzdd55fkgk3v5qy4axvrbny5lrr5s8dcn";
  };

  buildInputs = [libogg] ;
}
