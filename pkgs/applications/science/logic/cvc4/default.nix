{ stdenv, fetchFromGitHub, cln, gmp, swig, pkgconfig, readline, libantlr3c,
boost, jdk, autoreconfHook, python2, antlr3_4 }:

stdenv.mkDerivation rec {
  name = "cvc4-unstable-${version}";
  version = "2017-05-18";

  src = fetchFromGitHub {
    owner = "CVC4";
    repo = "CVC4";
    rev = "d77107cc56b0a089364c3d1512813701c155ea93";
    sha256 = "085bjrrm33rl5pwqx13af9sgni9cfbg70wag6lm08jj41ws411xs";
  };

  buildInputs = [ gmp cln pkgconfig readline swig libantlr3c antlr3_4 boost jdk autoreconfHook python2 ];
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
