{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, openssl
}:

stdenv.mkDerivation rec {
  pname = "btcdeb";
  version = "unstable-2022-04-03";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "btcdeb";
    rev = "3ba1ec7f4d37f7d2ff0544403465004c6e12036e";
    hash = "sha256-l/PGXXX288mnoSFZ32t2Xd13dC6JCU5wDHoDxb+fcp0=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Bitcoin Script Debugger";
    homepage = "https://github.com/bitcoin-core/btcdeb";
    license = licenses.mit;
    maintainers = with maintainers; [ akru ];
    platforms = platforms.unix;
  };
}
