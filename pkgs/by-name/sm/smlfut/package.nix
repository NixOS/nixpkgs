{ lib, stdenv, fetchFromGitHub, mlton, futhark }:

stdenv.mkDerivation rec {
  pname = "smlfut";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "diku-dk";
    repo = "smlfut";
    rev = "v${version}";
    hash = "sha256-Oj5+UNtV2GKB2GNsSFKePVpa1msSZwwJI/YElwBSH98=";
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
