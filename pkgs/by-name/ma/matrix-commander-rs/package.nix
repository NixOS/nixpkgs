{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "matrix-commander-rs";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-aecmd7LtHowH+nqLcRNDSfAxZDKtBTrG1KNyRup8CYI=";
  };

  cargoHash = "sha256-2biUWLWE0XtmB79yxFahQqLmqwH/6q50IhkcbUrBifU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = with lib; {
    description = "CLI-based Matrix client app for sending and receiving";
    homepage = "https://github.com/8go/matrix-commander-rs";
    changelog = "https://github.com/8go/matrix-commander-rs/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "matrix-commander-rs";
  };
}
