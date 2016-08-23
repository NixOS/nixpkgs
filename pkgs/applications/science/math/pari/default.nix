{ stdenv, fetchurl, gmp, readline }:

stdenv.mkDerivation rec {
  version = "2.7.6";
  name = "pari-${version}";

  src = fetchurl {
    url = "http://pari.math.u-bordeaux.fr/pub/pari/unix/${name}.tar.gz";
    sha256 = "04dqi697czd8mmw8aiwzrkgbvkjassqagg6lfy3lkf1k5qi9g9rr";
  };

  buildInputs = [gmp readline];

  configureScript = "./Configure";
  configureFlags =
    "--with-gmp=${gmp.dev} " +
    "--with-readline=${readline.dev}";

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
