{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, openssl
, db
}:

stdenv.mkDerivation rec {
  pname = "bruteforce-wallet";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "glv2";
    repo = "bruteforce-wallet";
    rev = version;
    hash = "sha256-1sMoVlQK3ceFOHyGeXKXUD35HmMxVX8w7qefZrzAj5k=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    openssl
    db
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Try to find password of encrypted cryptocurrency wallet";
    homepage = "https://github.com/glv2/bruteforce-wallet";
    changelog = "https://github.com/glv2/bruteforce-wallet/blob/${src.rev}/NEWS";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ octodi ];
    mainProgram = "bruteforce-wallet";
    platforms = platforms.linux;
  };
}
