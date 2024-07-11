{ lib, stdenv, fetchFromGitHub, perl, mlton }:

stdenv.mkDerivation {
  pname = "metis-prover";
  version = "2.4.20200713";

  src = fetchFromGitHub {
    owner = "gilith";
    repo = "metis";
    rev = "d17c3a8cf6537212c5c4bfdadcf865bd25723132";
    sha256 = "phu1x0yahK/B2bSOCvlze7UJw8smX9zw6dJTpDD9chM=";
  };

  nativeBuildInputs = [ perl ];
  buildInputs = [ mlton ];

  patchPhase = "patchShebangs .";

  buildPhase = "make mlton";

  installPhase = ''
    install -Dm0755 bin/mlton/metis $out/bin/metis
  '';

  meta = with lib; {
    description = "Automatic theorem prover for first-order logic with equality";
    mainProgram = "metis";
    homepage = "https://www.gilith.com/research/metis/";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
  };
}
