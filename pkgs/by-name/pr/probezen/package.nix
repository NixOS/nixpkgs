{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "probezen";
  version = "1.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HemVadgama";
    repo = "probezen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t9G84rxfM11oGK0R3cQT6XHeqOkRuc3LIBDIoHmaW30=";
  };

  pythonRelaxDeps = [ "rich" ];

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    httpx
    pyyaml
    rich
    typer
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "probezen" ];

  disabledTests = [
    # AssertionError
    "test_real_first_run_action_flow"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to detect behavioral drift in third-party APIs";
    homepage = "https://github.com/HemVadgama/probezen";
    changelog = "https://github.com/HemVadgama/probezen/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "probezen";
  };
})
