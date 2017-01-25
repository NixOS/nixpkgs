{ stdenv, fetchurl, gmp-static, gperf, autoreconfHook }:

stdenv.mkDerivation rec {
  name    = "yices-${version}";
  version = "2.5.1";

  src = fetchurl {
    url = "http://yices.csl.sri.com/cgi-bin/yices2-newnewdownload.cgi?file=yices-${version}-src.tar.gz&accept=I+Agree";
    name = "yices-${version}-src.tar.gz";
    sha256 = "1wfq6hcm54h0mqmbs1ip63i0ywlwnciav86sbzk3gafxyzg1nd0c";
  };

  patchPhase = ''patchShebangs tests/regress/check.sh'';

  configureFlags = [ "--with-static-gmp=${gmp-static.out}/lib/libgmp.a"
                     "--with-static-gmp-include-dir=${gmp-static.dev}/include"
                   ];
  buildInputs = [ gmp-static gperf autoreconfHook ];

  enableParallelBuilding = true;
  doCheck = true;

  installPhase = ''make install LDCONFIG=true'';

  meta = with stdenv.lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "http://yices.csl.sri.com";
    license     = licenses.unfreeRedistributable;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
