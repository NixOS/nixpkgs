{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "jql";
  version = "8.0.7";

  src = fetchFromGitHub {
    owner = "yamafaktory";
    repo = "jql";
    rev = "jql-v${version}";
    hash = "sha256-OBv7uScgFnLhkeQ2dKey+QYUvX4y/iLFjfCUJeqhXBs=";
  };

  cargoHash = "sha256-AAdYjlPpyhxKQ8mXdLBdivMp8G91Ho5ntS73HC8wMfQ=";

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
