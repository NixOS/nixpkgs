{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "runoff";
  version = "3.1.0-unstable-2026-05-01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Real-Fruit-Snacks";
    repo = "Runoff";
    rev = "fa566364f641fa0656654de2984919df0ddfc536";
    hash = "sha256-E5mMI5f9FS4zqiQrMQ5A8OHjhV6vCmH2ZNgjpMr9Z18=";
  };

  __structuredAttrs = true;

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    click
    neo4j
    pyyaml
    requests
    rich
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    types-pyyaml
    types-requests
  ];

  pythonImportsCheck = [ "runoff" ];

  disabledTests = [
    # rich.errors.MissingStyle: Failed to get style 'warn'...
    "test_with_results"
  ];

  meta = {
    description = "Active Directory security audit tool";
    homepage = "https://github.com/Real-Fruit-Snacks/Runoff";
    changelog = "https://github.com/Real-Fruit-Snacks/Runoff/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "runoff";
  };
})
