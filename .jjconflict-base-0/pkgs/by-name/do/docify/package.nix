{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "docify";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AThePeanut4";
    repo = "docify";
    tag = "v${version}";
    hash = "sha256-pENahqprTf6weP6qi9CyeQPdNOqr9c/q7j6GO9Lq3N4=";
  };

  build-system = with python3Packages; [
    pdm-backend
  ];

  dependencies = with python3Packages; [
    libcst
    tqdm
  ];

  pythonImportsCheck = [ "docify" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/AThePeanut4/docify/releases/tag/v${version}";
    description = "Script to add docstrings to Python type stubs using reflection";
    homepage = "https://github.com/AThePeanut4/docify";
    license = lib.licenses.mit;
    mainProgram = "docify";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
