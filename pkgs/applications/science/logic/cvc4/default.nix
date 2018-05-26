{ stdenv, fetchurl, cln, gmp, swig, pkgconfig
, readline, libantlr3c, boost, jdk, autoreconfHook
, python2, antlr3_4
}:

stdenv.mkDerivation rec {
  name = "cvc4-${version}";
  version = "1.5";

  src = fetchurl {
    url = "http://cvc4.cs.stanford.edu/downloads/builds/src/cvc4-${version}.tar.gz";
    sha256 = "0yxxawgc9vd2cz883swjlm76rbdkj48n7a8dfppsami530y2rvhi";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ gmp cln readline swig libantlr3c antlr3_4 boost jdk python2 ];
  configureFlags = [
    "--enable-language-bindings=c,c++,java"
    "--enable-gpl"
    "--with-cln"
    "--with-readline"
    "--with-boost=${boost.dev}"
  ];

  prePatch = ''
    patch -p1 -i ${./minisat-fenv.patch} -d src/prop/minisat
    patch -p1 -i ${./minisat-fenv.patch} -d src/prop/bvminisat
  '';

  preConfigure = ''
    patchShebangs ./src/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = http://cvc4.cs.nyu.edu/web/;
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ vbgl thoughtpolice ];
  };
}
