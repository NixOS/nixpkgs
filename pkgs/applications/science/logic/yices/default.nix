{ stdenv, fetchurl, gmp-static, gperf, autoreconfHook, libpoly }:

stdenv.mkDerivation rec {
  name    = "yices-${version}";
  version = "2.5.4";

  src = fetchurl {
    url = "https://github.com/SRI-CSL/yices2/archive/Yices-${version}.tar.gz";
    name = "${name}-src.tar.gz";
    sha256 = "1k8wmlddi3zv5kgg6xbch3a0s0xqsmsfc7y6z8zrgcyhswl36h7p";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs       = [ gmp-static gperf libpoly ];
  configureFlags =
    [ "--with-static-gmp=${gmp-static.out}/lib/libgmp.a"
      "--with-static-gmp-include-dir=${gmp-static.dev}/include"
      "--enable-mcsat"
    ];

  enableParallelBuilding = true;
  doCheck = true;

  # Usual shenanigans
  patchPhase = ''patchShebangs tests/regress/check.sh'';

  # Includes a fix for the embedded soname being libyices.so.2.5, but
  # only installing the libyices.so.2.5.x file.
  installPhase = ''
      make install LDCONFIG=true
      (cd $out/lib && ln -s -f libyices.so.${version} libyices.so.2.5)
  '';

  meta = with stdenv.lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "http://yices.csl.sri.com";
    license     = licenses.gpl3;
    platforms   = with platforms; linux ++ darwin;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
