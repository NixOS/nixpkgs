{ stdenv, fetchFromGitHub, cmake, gmp }:

stdenv.mkDerivation rec {
  pname = "lean";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner  = "leanprover-community";
    repo   = "lean";
    rev    = "v${version}";
    sha256 = "0m7knf1hfbn2v6p6kmqxlx8c40p5nzv8d975w2xwljaccc42j1yp";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gmp ];
  enableParallelBuilding = true;

  preConfigure = ''
    cd src
  '';

  meta = with stdenv.lib; {
    description = "Automatic and interactive theorem prover";
    homepage    = https://leanprover.github.io/;
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice gebner ];
  };
}

