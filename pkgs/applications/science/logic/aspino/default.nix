{ stdenv, fetchFromGitHub, zlib, boost, glucose }:
stdenv.mkDerivation rec {
  name = "aspino-2016-01-31";

  src = fetchFromGitHub {
    owner = "alviano";
    repo = "aspino";
    rev = "d28579b5967988b88bce6d9964a8f0a926286e9c";
    sha256 = "0r9dnkq3rldv5hhnmycmzqyg23hv5w3g3i5a00a8zalnzfiyirnq";
  };

  buildInputs = [ zlib boost ];

  patchPhase = ''
    substituteInPlace Makefile \
      --replace "GCC = g++" "GCC = c++"
  '';

  preBuild = ''
    cp ${glucose.src} patches/glucose-syrup.tgz
    ./bootstrap.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m0755 build/release/{aspino,fairino-{bs,ls,ps},maxino-2015-{k16,kdyn}} $out/bin
  '';

  meta = with stdenv.lib; {
    description = "SAT/PseudoBoolean/MaxSat/ASP solver using glucose";
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
    license = licenses.asl20;
    homepage = http://alviano.net/software/maxino/;
  };
}
