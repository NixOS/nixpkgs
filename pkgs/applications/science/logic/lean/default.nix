{ stdenv, fetchFromGitHub, cmake, gmp }:

stdenv.mkDerivation rec {
  pname = "lean";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner  = "leanprover-community";
    repo   = "lean";
    rev    = "v${version}";
    sha256 = "1filkhyqcjglbavbkjra0nk3y7hw8993wyl7r87ikydb2bjishsc";
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

