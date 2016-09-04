{ stdenv, fetchFromGitHub, cmake, gmp, mpfr, boost, python
, gperftools, ninja, makeWrapper }:

stdenv.mkDerivation rec {
  name = "lean-${version}";
  version = "2016-07-05";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean";
    rev    = "cc70845332e63a1f1be21dc1f96d17269fc85909";
    sha256 = "09qz2vjw7whiggvw0cdaa4i2f49wnch2sd4r43glq181ssln27d6";
  };

  buildInputs = [ gmp mpfr boost cmake python gperftools ninja makeWrapper ];
  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs bin/leantags
    cd src
  '';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  postInstall = ''
    wrapProgram $out/bin/linja --prefix PATH : $out/bin:${ninja}/bin
  '';

  meta = with stdenv.lib; {
    description = "Automatic and interactive theorem prover";
    homepage    = "http://leanprover.github.io";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice gebner ];
  };
}
