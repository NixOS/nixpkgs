{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "8.0.8";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = "jql";
    rev = "jql-v${version}";
    hash = "sha256-VujhFNC0nHFRZ5t/X6ZdEp5xpeMwEr0vPrpN9g/9c1U=";
  };

  cargoHash = "sha256-wkVHzFzQU9O2LAUmR6EYiCeFg29TxJVXJ2COJBB8BZw=";

  meta = with lib; {
    description = "JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${src.rev}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      akshgpt7
      figsoda
    ];
    mainProgram = "jql";
  };
}
