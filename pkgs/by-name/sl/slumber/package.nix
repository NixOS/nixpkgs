{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "refs/tags/v${version}";
    hash = "sha256-W7KvIc6FqM4RUqUsMOzfwBD9kVIFdqPba8dz+Ysg4sY=";
  };

  cargoHash = "sha256-1PNf7EVr4UibxR1OM04tDr5jreEeFxvKfx6Qe3p6dJQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}
