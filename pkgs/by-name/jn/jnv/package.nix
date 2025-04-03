{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "jnv";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    rev = "v${version}";
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
