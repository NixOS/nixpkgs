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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-UoqddgXrwaKtIE0cuAFkfrgmvLIDRpGjl5jBQvh9mdI=";
  };

  cargoHash = "sha256-cMXnMCiMeM4Tykquco7G3kcZC2xxoDl+uWqrQLFp1VM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
