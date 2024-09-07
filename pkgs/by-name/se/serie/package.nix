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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "serie";
    rev = "v${version}";
    hash = "sha256-LjWpWgOInnPL4Ke8Ntk+bEJBljPSEe14RCKzN50JUGA=";
  };

  cargoHash = "sha256-Ynnp7jSnkNHbL98JOXjV6v97IXWwi2HiZC5SkChCRv0=";

  buildInputs = lib.optionals stdenv.isDarwin (
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
