{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "serie";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${version}";
    hash = "sha256-PlWnkkrn+j6GyyBo6ehszXxDexyW4rjIfpCj1ZARBPc=";
  };

  cargoHash = "sha256-kKOjLLpWmgtfIYWrlX/6SRUy7NOX6A/W/Oy3kMGR3eg=";

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      CoreGraphics
      AppKit
    ]
  );

  # requires a git repository
  doCheck = false;

  meta = with lib; {
    description = "A rich git commit graph in your terminal, like magic";
    homepage = "https://github.com/lusingander/serie";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "serie";
  };
}
