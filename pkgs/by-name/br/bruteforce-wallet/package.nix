{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  openssl,
  db,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bruteforce-wallet";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "glv2";
    repo = "bruteforce-wallet";
    tag = finalAttrs.version;
    hash = "sha256-ngzG39c/bWv++PHVgce9r1PXElFhpgYoAepbqD/1Dq0=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    openssl
    db
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Try to find password of encrypted cryptocurrency wallet";
    homepage = "https://github.com/glv2/bruteforce-wallet";
    changelog = "https://github.com/glv2/bruteforce-wallet/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ octodi ];
    mainProgram = "bruteforce-wallet";
    platforms = lib.platforms.linux;
  };
})
