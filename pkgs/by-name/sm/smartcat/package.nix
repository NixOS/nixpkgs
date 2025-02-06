{
  lib,
  fetchFromGitHub,
  rustPlatform,

  darwin,
  openssl,
  pkg-config,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "smartcat";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "efugier";
    repo = "smartcat";
    tag = version;
    hash = "sha256-nXuMyHV5Sln3qWXIhIDdV0thSY4YbvzGqNWGIw4QLdM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-AiOVIDfARztwQxOzBFWc8NXEEsxEvKAStCokcRrJyOE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = {
    description = "Integrate large language models into the command line";
    homepage = "https://github.com/efugier/smartcat";
    changelog = "https://github.com/efugier/smartcat/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "sc";
    maintainers = with lib.maintainers; [ lpchaim ];
  };
}
