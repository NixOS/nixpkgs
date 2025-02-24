{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  openssl,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "btcdeb";
  version = "0.3.20-unstable-2024-04-09";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "btcdeb";
    rev = "e2c2e7b9fe2ecc0884129b53813a733f93a6e2c7";
    hash = "sha256-heV5VByNZ/2doGVtYhGEei4fV4847UPVgOyU0PDDHc8=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Bitcoin Script Debugger";
    homepage = "https://github.com/bitcoin-core/btcdeb";
    changelog = "https://github.com/bitcoin-core/btcdeb/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ akru ];
    platforms = platforms.unix;
  };
}
