{ stdenv, fetchurl
, pari, perl }:

stdenv.mkDerivation rec {

  name = "gp2c-${version}";
  version = "0.0.11";

  src = fetchurl {
    url = "https://pari.math.u-bordeaux.fr/pub/pari/GP2C/${name}.tar.gz";
    sha256 = "1z69xj2dpd8yyi8108rz26c50xpv0k2j8qnk0bzy1c5lw3pd1adm";
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
