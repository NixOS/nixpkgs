{
  lib,
  stdenv,
  fetchFromGitHub,
  mlton,
  mlkit,
  futhark,
}:

stdenv.mkDerivation rec {
  pname = "smlfut";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "diku-dk";
    repo = "smlfut";
    rev = "v${version}";
    hash = "sha256-0Bqgoyp43Y961BMghJFBUx+1lcM2HHlPDjPyLHquWiE=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ mlton ];

  env.MLCOMP = "mlton";

  installFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  nativeCheckInputs = [
    futhark
    mlkit
  ];

  checkTarget = "run_test";

  meta = {
    description = "Allow SML programs to call Futhark programs";
    homepage = "https://github.com/diku-dk/smlfut";
    license = lib.licenses.gpl3Plus;
    platforms = mlton.meta.platforms;
    maintainers = with lib.maintainers; [ athas ];
    mainProgram = "smlfut";
  };
}
