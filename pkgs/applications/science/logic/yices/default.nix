{ stdenv, fetchurl, gmp-static, gperf, autoreconfHook, libpoly }:

stdenv.mkDerivation rec {
  name    = "yices-${version}";
  version = "2.5.1";

  src = fetchurl {
    url = "http://yices.csl.sri.com/cgi-bin/yices2-newnewdownload.cgi?file=${name}-src.tar.gz&accept=I+Agree";
    name = "${name}-src.tar.gz";
    sha256 = "1wfq6hcm54h0mqmbs1ip63i0ywlwnciav86sbzk3gafxyzg1nd0c";
  };

  patchPhase = ''patchShebangs tests/regress/check.sh'';

  configureFlags = [ "--with-static-gmp=${gmp-static.out}/lib/libgmp.a"
                     "--with-static-gmp-include-dir=${gmp-static.dev}/include"
                     "--enable-mcsat"
                   ];
  buildInputs = [ gmp-static gperf autoreconfHook libpoly ];

  enableParallelBuilding = true;
  doCheck = true;

  # Includes a fix for the embedded soname being libyices.so.2.5, but
  # only installing the libyices.so.2.5.1 file.
  installPhase = ''
      make install LDCONFIG=true
      (cd $out/lib && ln -s -f libyices.so.2.5.1 libyices.so.2.5)
  '';

  meta = with stdenv.lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "http://yices.csl.sri.com";
    license     = licenses.unfreeRedistributable;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
