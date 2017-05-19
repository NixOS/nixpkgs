{ stdenv, fetchurl, cln, gmp, swig, pkgconfig, readline, libantlr3c, boost, jdk, autoreconfHook, python2 }:

stdenv.mkDerivation rec {
  name = "cvc4-${version}";
  version = "1.5pre-smtcomp2016";

  src = fetchurl {
    url = "http://cvc4.cs.nyu.edu/builds/src/cvc4-${version}.tar.gz";
    sha256 = "13dzigync44pfd3ppdapyd7zamfqv6kgiwcrvnds0piyar87g5w4";
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
