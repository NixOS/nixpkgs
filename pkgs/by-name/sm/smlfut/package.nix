{ lib, stdenv, fetchFromGitHub, mlton, futhark }:

stdenv.mkDerivation rec {
  pname = "smlfut";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "diku-dk";
    repo = "smlfut";
    rev = "v${version}";
    hash = "sha256-Ta0nCVD8N1k88sCdN4RhcugBgkQE7NdclCUtubgS6HM=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ mlton ];

  env.MLCOMP = "mlton";

  installFlags = ["PREFIX=$(out)"];

  doCheck = true;

  nativeCheckInputs = [ futhark ];

  checkTarget = "run_test";

  meta = with lib; {
    description = "Allow SML programs to call Futhark programs";
    homepage = "https://github.com/diku-dk/smlfut";
    license = licenses.gpl3Plus;
    platforms = mlton.meta.platforms;
    maintainers = with maintainers; [ athas ];
    mainProgram = "smlfut";
  };
}
