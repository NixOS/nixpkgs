{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "v${version}";
    hash = "sha256-BPOBIE/nAupBwjKYnEfrHQQ8EEA3ZbuU/D0fqio4Ir0=";
  };

  cargoHash = "sha256-+GXLCxitYjNK9Eg93Do1q6DglJ5QQi1KSZ6GNmJ1jG8=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}
