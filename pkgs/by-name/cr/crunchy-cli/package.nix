{ lib
, stdenv
, darwin
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "crunchy-cli";
  version = "3.6.6";

  src = fetchFromGitHub {
    owner = "crunchy-labs";
    repo = "crunchy-cli";
    rev = "v${version}";
    hash = "sha256-LVJRv8YUTfavc0ZrK2fIlgc5npQKwEZosoLEYw/V/pw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "native-tls-0.2.11" = "sha256-r+uvpwf1qgOVYuh+3xYOOsDWyCJnyG4Qc8i7RV2nzy4=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line downloader for Crunchyroll";
    homepage = "https://github.com/crunchy-labs/crunchy-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "crunchy-cli";
  };
}
