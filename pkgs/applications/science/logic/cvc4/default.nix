{ stdenv, fetchurl, cln, gmp, swig, pkgconfig, readline, libantlr3c, boost, jdk, autoreconfHook, python2 }:

stdenv.mkDerivation rec {
  name = "cvc4-${version}";
  version = "1.5pre-20170514";


  src = fetchurl {
    url = http://cvc4.cs.stanford.edu/downloads/builds/src/unstable/latest-unstable.tar.gz;
    sha256 = "0d56q7llx78f5mbhx6n4qhbq8c1pjl9a5azx823q7zyj70rmrwlq";
  };

  buildInputs = [ gmp cln pkgconfig readline swig libantlr3c boost jdk autoreconfHook python2 ];
  configureFlags = [
    "--enable-language-bindings=c,c++,java"
    "--enable-gpl"
    "--with-cln"
    "--with-readline"
    "--with-boost=${boost.dev}"
  ];
  preConfigure = ''
    patchShebangs ./src/
  '';

  meta = with stdenv.lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = http://cvc4.cs.nyu.edu/web/;
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ vbgl thoughtpolice ];
  };
}
