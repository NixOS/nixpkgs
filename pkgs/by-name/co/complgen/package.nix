{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "complgen";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    rev = "v${version}";
    hash = "sha256-pcMyI9jK5yyqZ7OlzDuG+9bK9QdZvXAxm4QS9awyqXk=";
  };

  cargoHash = "sha256-gZoK0EuULoZ5D6YPrjmn0Cv1Wu9t9xzJhP6/3OrBHeY=";

  meta = with lib; {
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    mainProgram = "complgen";
    homepage = "https://github.com/adaszko/complgen";
    changelog = "https://github.com/adaszko/complgen/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
