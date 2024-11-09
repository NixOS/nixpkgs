{ lib
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "pilfer";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "eludris";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4788W8dIaBVKVw8i+SB5I/SWgAfHzh1czBriQOA9CT0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "todel-${version}" = "sha256-1PBHV0cR8al9hk2OwMy9b12V+ccHtqCxuXpzyJ53DW8=";
    };
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = " A simple TUI for Eludris.";
    homepage = "https://github.com/eludris/pilfer";
    license = licenses.mit;
    maintainers = with maintainers; [ ooliver1 ];
  };
}
