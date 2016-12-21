{ stdenv, fetchFromGitHub, cmake, gmp, mpfr, gperftools }:

stdenv.mkDerivation rec {
  name = "lean-${version}";
  version = "2016-12-08";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "7b63d6566faaf1dc0f2c8e873c61f51dce9ab618";
    sha256 = "0xxr7dnh7pmdbpxhl3cq9clwamxjk54zcxplsrz6xirk0qy7ga4l";
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
