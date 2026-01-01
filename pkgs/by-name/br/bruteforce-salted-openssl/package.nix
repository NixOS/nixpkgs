{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "bruteforce-salted-openssl";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "glv2";
    repo = "bruteforce-salted-openssl";
    tag = version;
    hash = "sha256-hXB4CUQ5pihKmahyK359cgQACrs6YH1gHmZJAuTXgQM=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    openssl
  ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
    description = "Try to find the password of file encrypted with OpenSSL";
    homepage = "https://github.com/glv2/bruteforce-salted-openssl";
    changelog = "https://github.com/glv2/bruteforce-salted-openssl/blob/${src.rev}/NEWS";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ octodi ];
    mainProgram = "bruteforce-salted-openssl";
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Try to find the password of file encrypted with OpenSSL";
    homepage = "https://github.com/glv2/bruteforce-salted-openssl";
    changelog = "https://github.com/glv2/bruteforce-salted-openssl/blob/${src.rev}/NEWS";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ octodi ];
    mainProgram = "bruteforce-salted-openssl";
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
