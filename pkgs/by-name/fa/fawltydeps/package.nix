{
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "fawltydeps";
  version = "0.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "FawltyDeps";
    tag = "v${version}";
    hash = "sha256-RGwCi4SD0khuOZXcR9Leh9WtRautnlJIfuLBnosyUgk=";
  };

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    pyyaml
    importlib-metadata
    isort
    pip-requirements-parser
    pydantic
  ];

  nativeCheckInputs =
    [
      writableTmpDirAsHomeHook
    ]
    ++ (with python3Packages; [
      pytestCheckHook
      hypothesis
    ]);

  disabledTestPaths = [
    # Disable tests that require network
    "tests/test_install_deps.py"
    "tests/test_resolver.py"
  ];

  pythonImportsCheck = [ "fawltydeps" ];

  meta = {
    description = "Find undeclared and/or unused 3rd-party dependencies in your Python project";
    homepage = "https://tweag.github.io/FawltyDeps";
    license = lib.licenses.mit;
    mainProgram = "fawltydeps";
    maintainers = with lib.maintainers; [
      aleksana
      jherland
    ];
  };
}
