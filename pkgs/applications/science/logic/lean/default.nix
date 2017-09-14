{ stdenv, fetchFromGitHub, cmake, gmp }:

stdenv.mkDerivation rec {
  name = "lean-${version}";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "v${version}";
    sha256 = "13sb9rwgc9ni2j5zx77imjhkzhix9d7klsdb8cg68c17b20sy1g3";
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
