{ stdenv, fetchurl, gmp, readline }:

stdenv.mkDerivation rec {
  version = "2.7.4";
  name = "pari-${version}";

  src = fetchurl {
    url = "http://pari.math.u-bordeaux.fr/pub/pari/unix/${name}.tar.gz";
    sha256 = "0k1qqagfl6zn7gvwmsqffj6g9yrzqvszwh2mblhmxpjlw1pigfh8";
  };

  buildInputs = [gmp readline];

  configureScript = "./Configure";
  configureFlags =
    "--with-gmp=${gmp} " +
    "--with-readline=${readline}";

  meta = with stdenv.lib; {
    description = "Computer algebra system for high-performance number theory computations";
    homepage    = "http://pari.math.u-bordeaux.fr/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ ertes raskin ];
    platforms   = platforms.linux;

    inherit version;
    downloadPage = "http://pari.math.u-bordeaux.fr/download.html";
    updateWalker = true;
  };
}
