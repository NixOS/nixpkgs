{ stdenv, fetchFromGitHub, cmake, gmp, mpfr, luajit, boost, python
, gperftools, ninja }:

stdenv.mkDerivation rec {
  name = "lean-${version}";
  version = "20150821";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "453bd2341dac51e50d9bff07d5ff6c9c3fb3ba0b";
    sha256 = "1hmga5my123sra873iyqc7drj4skny4hnhsasaxjkmmdhmj1zpka";
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
