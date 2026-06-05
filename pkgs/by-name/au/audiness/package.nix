{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "audiness";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "audiusGmbH";
    repo = "audiness";
    tag = finalAttrs.version;
    hash = "sha256-row372NA8/DJbI6WJyGmKrlfuCsxUa5inhMljRzShT8=";
  };

  pythonRelaxDeps = [
    "typer"
    "validators"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    pytenable
    typer
    validators
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "audiness" ];

  meta = {
    description = "CLI tool to interact with Nessus";
    homepage = "https://github.com/audius/audiness";
    changelog = "https://github.com/audius/audiness/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "audiness";
  };
})
