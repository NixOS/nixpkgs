{ stdenv, fetchurl, qtbase, openssl, boost, cmake, scons, python, pcre, bzip2 }:

stdenv.mkDerivation {
  name = "robomongo-0.8.4";

  src = fetchurl {
    url = https://github.com/paralect/robomongo/archive/v0.8.4.tar.gz;
    sha256 = "199fb08701wrw3ky7gcqyvb3z4027qjcqdnzrx5y7yi3rb4gvkzc";
  };

  patches = [ ./robomongo.patch ];

  postPatch = ''
    rm ./cmake/FindOpenSSL.cmake # remove outdated bundled CMake file
  '';

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  buildInputs = [ cmake boost scons qtbase openssl python pcre bzip2 ];

  meta = {
    homepage = "http://robomongo.org/";
    description = "Query GUI for mongodb";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.amorsillo ];
    broken = true;
  };
}
