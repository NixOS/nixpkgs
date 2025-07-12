{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "rexi";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "royreznik";
    repo = "rexi";
    tag = "v${version}";
    hash = "sha256-tag2/QTM6tDCU3qr4e1GqRYAZgpvEgtA+FtR4P7WdiU=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    colorama
    typer
    textual
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  pythonRelaxDeps = [
    "textual"
    "typer"
  ];

  meta = {
    description = "User-friendly terminal UI to interactively work with regular expressions";
    homepage = "https://github.com/royreznik/rexi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gauravghodinde ];
    mainProgram = "rexi";
  };
}
