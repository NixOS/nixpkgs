{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
,
}:
rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "v${version}";
    hash = "sha256-sUCOuQ35wfbrLgiPdzw5wmr8BgzDinZDKfBJ3O9JrzI=";
  };

  cargoHash = "sha256-geTQ/56nuPW9fVtz+YEP3VaYPdWVm83hsGslKCtj0Vo=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}
