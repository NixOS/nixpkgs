{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, openssl
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "btcdeb";
  version = "0.3.20-unstable-2024-03-26";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "btcdeb";
    rev = "675b7820f0eec8a76f68ade7ea35974a561d49dd";
    hash = "sha256-J9E0edRbFONMut1/ZFaUqgWAtEUifc+pmGypeUQ0m4c=";
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
