{ stdenv, fetchFromGitHub, cmake, gmp, mpfr, python
, gperftools, ninja, makeWrapper }:

stdenv.mkDerivation {
  pname = "lean2";
  version = "2017-07-22";

  src = fetchFromGitHub {
    owner  = "leanprover";
    repo   = "lean2";
    rev    = "34dbd6c3ae612186b8f0f80d12fbf5ae7a059ec9";
    sha256 = "1xv3j487zhh1zf2b4v19xzw63s2sgjhg8d62a0kxxyknfmdf3khl";
  };

  buildInputs = [ gmp mpfr cmake python gperftools ninja makeWrapper ];
  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs bin/leantags
    cd src
  '';

  cmakeFlags = [ "-GNinja" ];

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
