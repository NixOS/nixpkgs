{ stdenv, fetchFromGitHub, cmake, gmp }:

stdenv.mkDerivation rec {
  name = "lean-${version}";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "v${version}";
    sha256 = "0w4cdai6mzx4wr7gscv4sl5q4mxx1agjbpp4smvrslav7gpbz025";
  };

  buildInputs = [ gmp cmake ];
  enableParallelBuilding = true;

  preConfigure = ''
    cd src
  '';

  meta = with stdenv.lib; {
    description = "Automatic and interactive theorem prover";
    homepage    = "http://leanprover.github.io";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice gebner ];
  };
}
