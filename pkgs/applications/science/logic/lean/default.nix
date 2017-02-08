{ stdenv, fetchFromGitHub, cmake, gmp, mpfr, gperftools }:

stdenv.mkDerivation rec {
  name = "lean-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "v${version}";
    sha256 = "1ds25213vir8llans7na3laqs8rgr06clgp9xzq8akiwfy87b74i";
  };

  buildInputs = [ gmp mpfr cmake gperftools ];
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
