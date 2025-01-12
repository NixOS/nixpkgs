{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "jnv";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ynqa";
    repo = "jnv";
    rev = "v${version}";
    hash = "sha256-ouWtMos4g9uIFEFeukgq8VgcxlSCzJnSYFNdNmOD5C8=";
  };

  cargoHash = "sha256-+/Xk5bb8GpyeKZii5rG/qboIxUqOyxwCSUCL9jtGHys=";

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
