{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "8.0.9";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = "jql";
    rev = "jql-v${version}";
    hash = "sha256-1gkKOOR2mIUKrbVb1BlFxVuskL6y7s6mrI99xTfjjTI=";
  };

  cargoHash = "sha256-7pSvHZqvPW9SXwU0AtQHIjgHQCSKPzrBhNxLY5ZAcMw=";

  meta = {
    description = "JSON Query Language CLI tool built with Rust";
    homepage = "https://github.com/yamafaktory/jql";
    changelog = "https://github.com/yamafaktory/jql/releases/tag/${src.rev}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      akshgpt7
      figsoda
    ];
    mainProgram = "jql";
  };
}
