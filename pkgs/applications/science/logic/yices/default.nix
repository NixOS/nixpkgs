{ stdenv, fetchurl, gmp, gperf, autoreconfHook }:

stdenv.mkDerivation rec {
  name    = "yices-${version}";
  version = "2.3.1";

  src = fetchurl {
    url = "http://yices.csl.sri.com/cgi-bin/yices2-newnewdownload.cgi?file=yices-2.3.1-src.tar.gz&accept=I+Agree";
    name = "yices-${version}-src.tar.gz";
    sha256 = "1da70n0cah0dh3pk7fcrvjkszx9qmhc0csgl15jqa7bdh707k2zs";
  };

  configureFlags = [ "--with-static-gmp=${gmp}/lib/libgmp.a"
                     "--with-static-gmp-include-dir=${gmp}/include"
                   ];
  buildInputs = [ gmp gperf autoreconfHook ];

  meta = {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "http://yices.csl.sri.com";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
