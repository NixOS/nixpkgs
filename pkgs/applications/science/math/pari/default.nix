{ stdenv, fetchurl, gmp, readline }:

stdenv.mkDerivation rec {
  name = "pari-2.5.4";

  src = fetchurl {
    url = "http://pari.math.u-bordeaux.fr/pub/pari/unix/${name}.tar.gz";
    sha256 = "0gpsj5n8d1gyl7nq2y915sscs3d334ryrv8qgjdwqf3cr95f2dwz";
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
