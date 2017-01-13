{ stdenv, fetchFromGitHub, cmake, gmp, mpfr, gperftools }:

stdenv.mkDerivation rec {
  name = "lean-${version}";
  version = "2017-01-06";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "6f8ccb5873b6f72d735e700e25044e99c6ebb7b6";
    sha256 = "1nxbqdc6faxivbrifb7b9j5zl5kml9w5pa63afh93z2ng7mn0jyg";
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
