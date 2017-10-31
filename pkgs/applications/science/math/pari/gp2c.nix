{ stdenv, fetchurl
, pari, perl }:

stdenv.mkDerivation rec {

  name = "gp2c-${version}";
  version = "0.0.10";

  src = fetchurl {
    url = "http://pari.math.u-bordeaux.fr/pub/pari/GP2C/${name}.tar.gz";
    sha256 = "1xhpz5p81iw261ay1kip283ggr0ir8ydz8qx3v24z8jfms1r3y70";
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
