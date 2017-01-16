{ stdenv, fetchFromGitHub, cmake, gmp, mpfr, gperftools }:

stdenv.mkDerivation rec {
  name = "lean-${version}";
  version = "2017-01-14";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "6e9a6d15dbfba3e8a1560d2cfcdbc7d81314d7bb";
    sha256 = "0wi1jssj1bi45rji4prlnvzs8nr48mqnj9yg5vnhah4rsjwl20km";
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
