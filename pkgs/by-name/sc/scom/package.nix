{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finaAttrs: {
  pname = "scom";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "crash-systems";
    repo = "scom";
    tag = finaAttrs.version;
    hash = "sha256-l1MSJ5+Fw33OEshmcQ+A/yU8BbMJHGR6jI7I/y3AVwU=";
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
