{ lib
, stdenv
, darwin
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "crunchy-cli";
  version = "3.2.5";

  src = fetchFromGitHub {
    owner = "crunchy-labs";
    repo = "crunchy-cli";
    rev = "v${version}";
    hash = "sha256-hzmTwUd+bQwr+5UtXKMalJZUDxOC5nhXNTXbYZN8xtA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "native-tls-0.2.11" = "sha256-+NeXsxuThKNOzVLBItKcuTAM/0zR/BzJGMKkuq99gBM=";
    };
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "Command-line downloader for Crunchyroll";
    homepage = "https://github.com/crunchy-labs/crunchy-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ stepbrobd ];
    mainProgram = "crunchy-cli";
  };
}
