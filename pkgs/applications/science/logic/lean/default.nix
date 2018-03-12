{ stdenv, fetchFromGitHub, cmake, gmp }:

stdenv.mkDerivation rec {
  name = "lean-${version}";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "v${version}";
    sha256 = "0irh9b4haz0pzzxrb4hwcss91a0xb499kjrcrmr2s59p3zq8bbd9";
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
