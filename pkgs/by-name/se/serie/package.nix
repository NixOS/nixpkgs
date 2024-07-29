{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "serie";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${version}";
    hash = "sha256-81DXu5SSL5TWtnIDBWCWlatRtEL00h4vOnRA0HuTInQ=";
  };

  cargoHash = "sha256-Vx3UGsWvudW33CFGU8rS+QCANxG7aXBf0zkYJxcUVps=";

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
