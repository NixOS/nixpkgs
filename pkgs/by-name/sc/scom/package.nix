{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finaAttrs: {
  pname = "scom";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "crash-systems";
    repo = "scom";
    tag = finaAttrs.version;
    hash = "sha256-z/y4SB0R3nxiBGAWLGBsRH0tncDuBxpjy6NGG8ZbIPw=";
  };

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Minimal serial communication tool";
    homepage = "https://github.com/crash-systems/scom";
    mainProgram = "scom";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ savalet ];
    platforms = lib.platforms.unix;
  };
})
