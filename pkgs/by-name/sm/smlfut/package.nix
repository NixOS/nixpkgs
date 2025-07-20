{
  lib,
  stdenv,
  fetchFromGitHub,
  mlton,
  mlkit,
  futhark,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smlfut";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "diku-dk";
    repo = "smlfut";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xICcobdvSdHZfNxz4WRDOsaL4JGFRK7LmhMzKOZY5FY=";
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

  meta = with lib; {
    description = "Allow SML programs to call Futhark programs";
    homepage = "https://github.com/diku-dk/smlfut";
    license = licenses.gpl3Plus;
    platforms = mlton.meta.platforms;
    maintainers = with maintainers; [ athas ];
    mainProgram = "smlfut";
  };
})
