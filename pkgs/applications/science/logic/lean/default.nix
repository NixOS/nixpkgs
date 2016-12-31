{ stdenv, fetchFromGitHub, cmake, gmp, mpfr, gperftools }:

stdenv.mkDerivation rec {
  name = "lean-${version}";
  version = "2016-12-30";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "fd4fffea27c442b12a45f664a8680ebb47482ca3";
    sha256 = "1izbjxbr1nvv5kv2b7qklqjx2b1qmwrxhmvk0f2lrl9pxz9h0bmd";
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
