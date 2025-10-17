{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "specify-cli";
  version = "0.0.52";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "spec-kit";
    tag = "v${version}";
    hash = "sha256-Z940x+CuJWTYFrvaCvdOazRstfLFUhcCnipiE3dlvR4=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    httpx
    httpx.optional-dependencies.socks
    platformdirs
    readchar
    rich
    truststore
    typer
  ];

  pythonImportsCheck = [
    "specify_cli"
  ];

  meta = {
    description = "Tool to bootstrap your projects for Spec-Driven Development (SDD)";
    homepage = "https://github.com/github/spec-kit";
    changelog = "https://github.com/github/spec-kit/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "specify";
  };
}
