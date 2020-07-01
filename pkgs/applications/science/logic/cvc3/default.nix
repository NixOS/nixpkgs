{ stdenv, fetchurl, flex, bison, gmp, perl }:

stdenv.mkDerivation rec {
    pname = "cvc3";
    version = "2.4.1";

    src = fetchurl {
      url = "http://www.cs.nyu.edu/acsys/cvc3/releases/${version}/${pname}-${version}.tar.gz";
      sha256 = "1xxcwhz3y6djrycw8sm6xz83wb4hb12rd1n0skvc7fng0rh1snym";
    };

  buildInputs = [ gmp flex bison perl ];

  patches = [ ./cvc3-2.4.1-gccv6-fix.patch ];

  preConfigure = ''
    sed -e "s@ /bin/bash@bash@g" -i Makefile.std
    find . -exec sed -e "s@/usr/bin/perl@${perl}/bin/perl@g" -i '{}' ';'
  '';

  meta = with stdenv.lib; {
    description = "A prover for satisfiability modulo theory (SMT)";
    maintainers = with maintainers;
      [ raskin ];
    platforms = platforms.linux;
    license = licenses.free;
    homepage = "http://www.cs.nyu.edu/acsys/cvc3/index.html";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.cs.nyu.edu/acsys/cvc3/download.html";
    };
  };
}
