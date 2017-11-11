{ stdenv, fetchurl, gmp, readline, perl }:

stdenv.mkDerivation rec {
  version = "2.9.3";
  name = "pari-unstable-${version}";

  src = fetchurl {
    url = "http://pari.math.u-bordeaux.fr/pub/pari/unstable/pari-${version}.tar.gz";
    sha256 = "0qqal1lpggd6dvs19svnz0dil86xk0xkcj5s3b7104ibkmvjfsp7";
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
