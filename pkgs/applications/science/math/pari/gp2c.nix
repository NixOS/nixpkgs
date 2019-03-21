{ stdenv, fetchurl
, pari, perl }:

stdenv.mkDerivation rec {

  name = "gp2c-${version}";
  version = "0.0.11pl1";

  src = fetchurl {
    url = "https://pari.math.u-bordeaux.fr/pub/pari/GP2C/${name}.tar.gz";
    sha256 = "1c6f6vmncw032kfzrfyr8bynw6yd3faxpy2285r009fmr0zxfs5s";
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
