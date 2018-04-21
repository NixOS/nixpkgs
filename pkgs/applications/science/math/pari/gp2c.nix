{ stdenv, fetchurl
, pari, perl }:

stdenv.mkDerivation rec {

  name = "gp2c-${version}";
  version = "0.0.10pl1";

  src = fetchurl {
    url = "http://pari.math.u-bordeaux.fr/pub/pari/GP2C/${name}.tar.gz";
    sha256 = "16hgmdvzxbmv63x1f72q1xgfyh0qhx7kaf9nbaamy0gdawxjxcav";
  };

  buildInputs = [ pari perl ];

  configureFlags = [
    "--with-paricfg=${pari}/lib/pari/pari.cfg"
    "--with-perl=${perl}/bin/perl" ];

  meta = with stdenv.lib; {
    description =  "A compiler to translate GP scripts to PARI programs";
    homepage    = "http://pari.math.u-bordeaux.fr/";
    downloadPage = "http://pari.math.u-bordeaux.fr/download.html";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
# TODO: add it as "source file" for default package
