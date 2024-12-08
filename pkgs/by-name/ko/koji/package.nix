{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, perl
, udev
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "koji";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "its-danny";
    repo = "koji";
    rev = version;
    hash = "sha256-2kBjHX7izo4loJ8oyPjE9FtCvUODC3Sm4T8ETIdeGZM=";
  };

  cargoHash = "sha256-owppYDt0YdWoDvfmzVfiIPjLgTAT9eTI1LpRr4Y3XQA=";

  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    perl
    udev
  ];

  buildInputs = [
    openssl.dev
  ];

  meta = with lib; {
    description = "Interactive CLI for creating conventional commits";
    homepage = "https://github.com/its-danny/koji";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ByteSudoer ];
    mainProgram = "koji";
    platforms = platforms.unix;
  };
}
