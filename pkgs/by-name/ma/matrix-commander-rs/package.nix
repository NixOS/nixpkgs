{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "matrix-commander-rs";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander-rs";
    tag = "v${version}";
    hash = "sha256-eEkSdr6qHLUBp4natvq7uMbcqxDOTJAE1vEPWLE3KKM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-I7g3yNjq1i7YXv6S7PPZnOQ0Y5665dNayz7XEQl/WAE=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = {
    description = "CLI-based Matrix client app for sending and receiving";
    homepage = "https://github.com/8go/matrix-commander-rs";
    changelog = "https://github.com/8go/matrix-commander-rs/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "matrix-commander-rs";
  };
}
