{ stdenv, fetchurl, gmp, readline }:

stdenv.mkDerivation rec {
  name = "pari-2.5.5";

  src = fetchurl {
    url = "http://pari.math.u-bordeaux.fr/pub/pari/unix/${name}.tar.gz";
    sha256 = "058nw1fhggy7idii4f124ami521lv3izvngs9idfz964aks8cvvn";
  };

  buildInputs = [gmp readline];

  configureScript = "./Configure";
  configureFlags =
    "--with-gmp=${gmp} " +
    "--with-readline=${readline}";

  meta = {
    description = "Computer algebra system for high-performance number theory computations";
    homepage    = "http://pari.math.u-bordeaux.fr/";
    license     = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [ertes raskin];
    platforms   = stdenv.lib.platforms.linux;
  };
}
