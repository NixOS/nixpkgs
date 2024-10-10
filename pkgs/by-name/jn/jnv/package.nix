{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "jnv";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    rev = "v${version}";
    hash = "sha256-B0BHef7szQayPwtRrfyf1ebirc1jCsxJG8UIye8MVNc=";
  };

  cargoHash = "sha256-m+Lmwljot27mXQSuCy+T7fK89L8SrwyO4lTfn8MzbOY=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      CoreGraphics
      AppKit
    ]
  );

  meta = with lib; {
    description = "Interactive JSON filter using jq";
    mainProgram = "jnv";
    homepage = "https://github.com/ynqa/jnv";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
      nealfennimore
      nshalman
    ];
  };
}
