{
  lib,
  fetchFromGitHub,
  python3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "dco-check";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "christophebedard";
    repo = "dco-check";
    tag = version;
    hash = "sha256-ux844Hc1D1CcW6T1M3OYW02NWfU6yyWCimFHFLI4J4o=";
  };

  build-system = with python3.pkgs; [ setuptools ];
  dependencies = with python3.pkgs; [
    flake8
    mypy
  ];
  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  meta = {
    description = "Simple DCO check script to be used in any CI";
    homepage = "https://github.com/christophebedard/dco-check";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ embr ];
    mainProgram = "dco-check";
  };
}
