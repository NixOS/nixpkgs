{ lib, stdenv, fetchurl, flex, bison, gmp, perl }:

stdenv.mkDerivation rec {
    pname = "cvc3";
    version = "2.4.1";

    src = fetchurl {
      url = "https://cs.nyu.edu/acsys/cvc3/releases/${version}/${pname}-${version}.tar.gz";
      sha256 = "1xxcwhz3y6djrycw8sm6xz83wb4hb12rd1n0skvc7fng0rh1snym";
    };

  buildInputs = [ gmp flex bison perl ];

  patches = [ ./cvc3-2.4.1-gccv6-fix.patch ];

  # fails to configure on darwin due to gmp not found
  configureFlags = [ "LIBS=-L${gmp}/lib" "CXXFLAGS=-I${gmp.dev}/include" ];

  postPatch = ''
    sed -e "s@ /bin/bash@bash@g" -i Makefile.std
    find . -exec sed -e "s@/usr/bin/perl@${perl}/bin/perl@g" -i '{}' ';'

    # bison 3.7 workaround
    for f in parsePL parseLisp parsesmtlib parsesmtlib2 ; do
      ln -s ../parser/''${f}_defs.h src/include/''${f}.hpp
    done
  '';

  meta = with lib; {
    description = "Prover for satisfiability modulo theory (SMT)";
    mainProgram = "cvc3";
    maintainers = with maintainers;
      [ raskin ];
    platforms = platforms.unix;
    license = licenses.free;
    homepage = "https://cs.nyu.edu/acsys/cvc3/index.html";
  };
  passthru = {
    updateInfo = {
      downloadPage = "https://cs.nyu.edu/acsys/cvc3/download.html";
    };
  };
}
