{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jnv";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HKZ+hF5Y7vTA4EODSAd9xYJHaipv5YukTl470ejPLtM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VLVoURqmUhhekNZ0a75bwjvSiLfaQ79IlltbmWVyBrI=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      CoreGraphics
      AppKit
    ]
  );

  meta = {
    description = "Interactive JSON filter using jq";
    mainProgram = "jnv";
    homepage = "https://github.com/ynqa/jnv";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      nealfennimore
      nshalman
    ];
  };
})
