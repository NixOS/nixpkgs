{ stdenv, fetchFromGitHub, cmake, gmp }:

stdenv.mkDerivation rec {
  name = "lean-${version}";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "v${version}";
    sha256 = "0zpnfg6kyg120rrdr336i1lymmzz4xgcqpn96iavhzhlaanmx55l";
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
