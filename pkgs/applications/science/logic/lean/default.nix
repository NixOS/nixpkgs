{ stdenv, fetchFromGitHub, cmake, gmp }:

stdenv.mkDerivation rec {
  pname = "lean";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner  = "leanprover-community";
    repo   = "lean";
    rev    = "v${version}";
    sha256 = "0crcpzbz75mdyi1vi4mygw3mj4lx73vff58fkic1gfxlpwrwgi20";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gmp ];
  enableParallelBuilding = true;

  preConfigure = ''
    cd src
  '';

  meta = with stdenv.lib; {
    description = "Automatic and interactive theorem prover";
    homepage    = "https://leanprover.github.io/";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice gebner ];
  };
}

