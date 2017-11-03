{ stdenv, fetchurl, gmp-static, gperf, autoreconfHook, libpoly }:

stdenv.mkDerivation rec {
  name    = "yices-${version}";
  version = "2.5.3";

  src = fetchurl {
    url = "https://github.com/SRI-CSL/yices2/archive/Yices-${version}.tar.gz";
    name = "${name}-src.tar.gz";
    sha256 = "0a3zzbvmgyiljzqn6xmc037gismm779p696jywk09j2pqbvp52ac";
  };

  patchPhase = ''patchShebangs tests/regress/check.sh'';

  configureFlags = [ "--with-static-gmp=${gmp-static.out}/lib/libgmp.a"
                     "--with-static-gmp-include-dir=${gmp-static.dev}/include"
                     "--enable-mcsat"
                   ];
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ gmp-static gperf libpoly ];

  enableParallelBuilding = true;
  doCheck = true;

  # Includes a fix for the embedded soname being libyices.so.2.5, but
  # only installing the libyices.so.2.5.1 file.
  installPhase = ''
      make install LDCONFIG=true
      (cd $out/lib && ln -s -f libyices.so.2.5.3 libyices.so.2.5)
  '';

  meta = with stdenv.lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "http://yices.csl.sri.com";
    license     = licenses.gpl3;
    platforms   = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
