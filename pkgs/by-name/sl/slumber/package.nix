{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
,
}:
rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "v${version}";
    hash = "sha256-Rww0hJlOw7Psy6Ro1/h15hjL5EjES4hohxj0DNhpMhE=";
  };

  cargoHash = "sha256-HDQJP7FcFjjB8Put68dGCzbDPmpaA0jLFM7oGbWAZ9s=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}
