{ stdenv, fetchurl, gmp, readline, perl }:

stdenv.mkDerivation rec {
  version = "2.8.1.beta";
  name = "pari-unstable-${version}";

  src = fetchurl {
    url = "http://pari.math.u-bordeaux.fr/pub/pari/unstable/pari-${version}.tar.gz";
    sha256 = "167dcqrqsblqrd7z5pb8jrs9xqm8138mik0s4ihlqcq6c3wndhv1";
  };

  buildInputs = [gmp readline];
  nativeBuildInputs = [perl];

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
