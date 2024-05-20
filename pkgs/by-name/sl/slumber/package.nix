{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "v${version}";
    hash = "sha256-Qg2Tn0f/5a1tzD7mdPm+d6di1k+o1PKLUjpV7Hv8wpY=";
  };

  cargoHash = "sha256-mWKMnE47fl04TvkgB5h3U/Y8TKUcdxDQdIwFiK7kGf4=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}
