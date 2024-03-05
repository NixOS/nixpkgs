{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, openssl
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "btcdeb";
  version = "0.3.20-unstable-2024-02-06";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "btcdeb";
    rev = "b9288fc3371eb1d9be0cae2549be25de66659be8";
    hash = "sha256-IieLNMA3m6g2Kn7g3iewmUL9c+meMR4hrrwVYqNZoh8=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "Bitcoin Script Debugger";
    homepage = "https://github.com/bitcoin-core/btcdeb";
    license = licenses.mit;
    maintainers = with maintainers; [ akru ];
    platforms = platforms.unix;
  };
}
