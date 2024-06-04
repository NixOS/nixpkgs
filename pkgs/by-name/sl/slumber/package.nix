{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
,
}:
rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "v${version}";
    hash = "sha256-aYNsTAqMcoOSRXWclrVR5DWQCTSDHXSQsSJn37yYPY8=";
  };

  cargoHash = "sha256-uSKE8jFLYCEac2PR97VSPBnqllTsXkYZUO0b+xHR/CA=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}
