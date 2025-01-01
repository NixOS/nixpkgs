{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  testers,
  gitMinimal,
  serie,
}:

rustPlatform.buildRustPackage rec {
  pname = "serie";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${version}";
    hash = "sha256-RP9Tv6IrDfawjXCQp0nB0nd7b6IwkdykHcEfGEguFHo=";
  };

  cargoHash = "sha256-HxIyWlFKDRod5nSENZguNYz/vn+E9Ux0K3dMhX7I/zQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      CoreGraphics
      AppKit
    ]
  );

  nativeCheckInputs = [ gitMinimal ];

  passthru.tests.version = testers.testVersion { package = serie; };

  meta = with lib; {
    description = "A rich git commit graph in your terminal, like magic";
    homepage = "https://github.com/lusingander/serie";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "serie";
  };
}
