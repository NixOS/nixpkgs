{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "rustmission";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "intuis";
    repo = "rustmission";
    rev = "v${version}";
    hash = "sha256-V9sy3rkoI3mKpeZjXT4D3Bs4NVETJ8h43iwOoDx1MKU=";
  };

  cargoHash = "sha256-KYg+SVAvlQn77kI1gyzXlzhKgPECYPZKICnmkcEnuh8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # There is no tests
  doCheck = false;

  meta = {
    description = "A TUI for the Transmission daemon";
    homepage = "https://github.com/intuis/rustmission";
    changelog = "https://github.com/intuis/rustmission/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "rustmission";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
