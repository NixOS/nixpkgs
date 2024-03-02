{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, openssl
}:

stdenv.mkDerivation rec {
  pname = "bruteforce-salted-openssl";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "glv2";
    repo = "bruteforce-salted-openssl";
    rev = version;
    hash = "sha256-ICxXdKjRP2vXdJpjn0PP0/6rw9LKju0nVOSj47TyrzY=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    openssl
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Try to find the password of file encrypted with OpenSSL";
    homepage = "https://github.com/glv2/bruteforce-salted-openssl";
    changelog = "https://github.com/glv2/bruteforce-salted-openssl/blob/${src.rev}/NEWS";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ octodi ];
    mainProgram = "bruteforce-salted-openssl";
    platforms = platforms.linux;
  };
}
