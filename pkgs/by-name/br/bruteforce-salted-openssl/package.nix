{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bruteforce-salted-openssl";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "glv2";
    repo = "bruteforce-salted-openssl";
    tag = finalAttrs.version;
    hash = "sha256-hXB4CUQ5pihKmahyK359cgQACrs6YH1gHmZJAuTXgQM=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    openssl
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Try to find the password of file encrypted with OpenSSL";
    homepage = "https://github.com/glv2/bruteforce-salted-openssl";
    changelog = "https://github.com/glv2/bruteforce-salted-openssl/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ octodi ];
    mainProgram = "bruteforce-salted-openssl";
    platforms = lib.platforms.linux;
  };
})
