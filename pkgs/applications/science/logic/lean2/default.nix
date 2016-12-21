{ stdenv, fetchFromGitHub, cmake, gmp, mpfr, boost, python
, gperftools, ninja, makeWrapper }:

stdenv.mkDerivation rec {
  name = "lean2-${version}";
  version = "2016-11-29";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean2";
    rev    = "a086fb334838c427bbc8f984eb44a4cbbe013a6b";
    sha256 = "0qlvhnb37amclgcyizl8bfab33b0a3jk54br9gsrik8cq76lkwwx";
  };

  buildInputs = [ gmp mpfr cmake python gperftools ninja makeWrapper ];
  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs bin/leantags
    cd src
  '';

  postInstall = ''
    wrapProgram $out/bin/linja --prefix PATH : $out/bin:${ninja}/bin
  '';

  meta = with stdenv.lib; {
    description = "Automatic and interactive theorem prover (version with HoTT support)";
    homepage    = "http://leanprover.github.io";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice gebner ];
  };
}
