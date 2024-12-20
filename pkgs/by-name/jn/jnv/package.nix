{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "jnv";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    rev = "v${version}";
    hash = "sha256-FkOcNQR/YyCufk7U4gdkmDBwkKns4Yze/T2Wx4PUFa8=";
  };

  cargoHash = "sha256-bX/a/GKUph8PocXxfOHQ+XfqFHtbnET0vSAwvSUqQzw=";

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
