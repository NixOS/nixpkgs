{ stdenv, fetchFromGitHub, cmake, gmp, mpfr, luajit, boost, python
, gperftools, ninja, makeWrapper }:

stdenv.mkDerivation rec {
  name = "lean-${version}";
  version = "20160117";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "b2554dcb8f45899ccce84f226cd67b6460442930";
    sha256 = "1gr024bly92kdjky5qvcm96gn86ijakziiyrsz91h643n1iyxhms";
  };

  buildInputs = [ gmp mpfr luajit boost cmake python gperftools ninja makeWrapper ];
  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs bin/leantags
    cd src
  '';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  postInstall = ''
    wrapProgram $out/bin/linja --prefix PATH : $out/bin:${ninja}/bin
  '';

  meta = {
    description = "Automatic and interactive theorem prover";
    homepage    = "http://leanprover.github.io";
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
