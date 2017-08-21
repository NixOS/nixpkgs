{ stdenv, fetchurl, gmp-static, gperf, autoreconfHook, libpoly }:

stdenv.mkDerivation rec {
  name    = "yices-${version}";
  version = "2.5.2";

  src = fetchurl {
    url = "http://yices.csl.sri.com/cgi-bin/yices2-newnewdownload.cgi?file=${name}-src.tar.gz&accept=I+Agree";
    name = "${name}-src.tar.gz";
    sha256 = "18mjnwg0pwc0fx4f99l7hxsi10mb5skkzk0k1m3xv5kx3qfnghs0";
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
      (cd $out/lib && ln -s -f libyices.so.2.5.2 libyices.so.2.5)
  '';

  meta = with stdenv.lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "http://yices.csl.sri.com";
    license     = licenses.unfreeRedistributable;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
