{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "audiness";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "audiusGmbH";
    repo = "audiness";
    tag = finalAttrs.version;
    hash = "sha256-zru37eNQyY9AcbALge1qlINuxzVKq3RTNypm5Pyhkz8=";
  };

  pythonRelaxDeps = [
    "typer"
    "validators"
  ];

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    pytenable
    typer
    validators
  ];

  nativeCheckInputs = with python3Packages; [
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
