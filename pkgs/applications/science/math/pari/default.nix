{ stdenv, fetchurl, gmp, readline }:

stdenv.mkDerivation rec {
  version = "2.7.5";
  name = "pari-${version}";

  src = fetchurl {
    url = "http://pari.math.u-bordeaux.fr/pub/pari/unix/${name}.tar.gz";
    sha256 = "0c8l83a0gjq73r9hndsrzkypwxvnnm4pxkkzbg6jm95m80nzwh11";
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
