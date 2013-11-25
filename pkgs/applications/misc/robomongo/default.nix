{ stdenv, fetchurl, qt5, openssl, boost, cmake, scons, python, pcre, bzip2 }:

stdenv.mkDerivation {
  name = "robomongo-0.8.3";

  src = fetchurl {
    url = https://github.com/paralect/robomongo/archive/v0.8.3.tar.gz;
    sha256 = "1x8vpmqvjscjcw30hf0i5vsrg3rldlwx6z52i1hymlck2jfzkank";
  };

  patches = [ ./robomongo.patch ];
  
  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  buildInputs = [ cmake boost scons qt5 openssl python pcre bzip2 ];

  meta = {
    homepage = "http://robomongo.org/";
    description = "Query GUI for mongodb";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.amorsillo ];
  };
}
