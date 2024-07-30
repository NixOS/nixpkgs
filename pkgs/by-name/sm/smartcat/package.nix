{ lib
, fetchFromGitHub
, rustPlatform

, darwin
, libX11
, openssl
, pkg-config
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "smartcat";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "efugier";
    repo = "smartcat";
    rev = "refs/tags/${version}";
    hash = "sha256-iCtNNKXo0peGGUaQXKaaYaEo7MAL70PX0BAWPERNmlo=";
  };

  cargoHash = "sha256-qNl2bI5VqpMfoFc+gZC4XHrNT9pnWseduYSOi5Dzr9M=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    libX11
  ]
  ++ lib.optionals stdenv.isDarwin [
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
