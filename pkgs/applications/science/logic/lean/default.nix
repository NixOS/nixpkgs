{ stdenv, fetchFromGitHub, cmake, gmp, mpfr, luajit, boost, python
, gperftools, ninja }:

stdenv.mkDerivation rec {
  name = "lean-20150328";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "1b15036dba469020d37f7d6b77b88974d8a36cb1";
    sha256 = "0w38g83gp7d3ybfiz9jpl2jz3ljad70bxmar0dnnv45wx42clg96";
  };

  buildInputs = [ gmp mpfr luajit boost cmake python gperftools ninja ];
  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs bin/leantags
    cd src
  '';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  meta = {
    description = "Automatic and interactive theorem prover";
    homepage    = "http://leanprover.github.io";
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
