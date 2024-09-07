{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "refs/tags/v${version}";
    hash = "sha256-u+IONDK3X+4kPmW9YXa0qQbAezBD+UADnlNEH1coKNE=";
  };

  cargoHash = "sha256-V/wPzEoUppLu8E5/SbBT4sPftz/SIg4s00/AHQL9R+o=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}
