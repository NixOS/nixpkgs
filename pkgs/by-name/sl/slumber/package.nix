{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "refs/tags/v${version}";
    hash = "sha256-TfJAVXJssnKj/RREetFBWgJcGNdpCTF7KUu3CrigF08=";
  };

  cargoHash = "sha256-jLBid9MDQ2eMhG0knxU1gxbi+eRFlCPYRkzWnjCnyG0=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}
