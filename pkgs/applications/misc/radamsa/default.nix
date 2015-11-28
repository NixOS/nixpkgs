{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "radamsa-0.4";

  src = fetchurl {
    url = "http://haltp.org/download/radamsa-0.4.tar.gz";
    sha256 = "1xs9dsrq6qrf104yi9x21scpr73crfikbi8q9njimiw5c1y6alrv";
  };

  buildInputs = [ stdenv.cc ];

  buildPhase = ''
    substitute Makefile Makefile \
      --replace /usr $out
    make bin/radamsa
  '';

  /*
  installPhase = ''
    mkdir -p $out/bin
    cp ./bin/radamsa $out/bin
    mkdir -p $out/share/
  '';
*/
 
  meta = {
    description = "A general purpose fuzzer";
    homepage = https://github.com/aoh/radamsa.git;
    maintainers = [ stdenv.lib.maintainers.markWot ];
    platforms = stdenv.lib.platforms.all;
  };
}
