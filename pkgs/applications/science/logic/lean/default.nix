{ stdenv, fetchFromGitHub, cmake, gmp }:

stdenv.mkDerivation rec {
  name = "lean-${version}";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "v${version}";
    sha256 = "0ww8azlyy3xikhd7nh96f507sg23r53zvayij1mwv5513vmblhhw";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gmp ];
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
