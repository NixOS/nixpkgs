{ stdenv, fetchurl, gmp, flex, bison }:

stdenv.mkDerivation rec {
  name = "veriT-${version}";
  version = "201410";

  src = fetchurl {
    url = "http://www.verit-solver.org/distrib/${name}.tar.gz";
    sha256 = "0b31rl3wjn3b09jpka93lx83d26m8a5pixa216vq8pmjach8q5a3";
  };

  buildInputs = [ gmp flex bison ];

  enableParallelBuilding = false;

  makeFlags = [
    "EXTERN=" # use system copy of gmp
  ];

  installPhase = ''
    install -D -m0755 veriT $out/bin/veriT
  '';

  meta = with stdenv.lib; {
    description = "An open, trustable and efficient SMT-solver";
    homepage = http://www.verit-solver.org/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.gebner ];
  };
}
