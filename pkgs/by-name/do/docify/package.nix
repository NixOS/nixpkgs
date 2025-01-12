{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "docify";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AThePeanut4";
    repo = "docify";
    rev = "refs/tags/v${version}";
    hash = "sha256-pt35Kw0kaZsIGTutXPhjdp8czGtWrSUFWMV3NyFQ/NM=";
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
