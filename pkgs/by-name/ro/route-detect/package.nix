{
  lib,
  fetchFromGitHub,
  python3,
  semgrep,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "route-detect";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mschwager";
    repo = "route-detect";
    rev = "refs/tags/${version}";
    hash = "sha256-4WkYjAQyteHJTJvSZoSfVUnBvsDQ3TWb5Ttp3uCgvdU=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = [ semgrep ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "routes" ];

  meta = {
    description = "Find authentication (authn) and authorization (authz) security bugs in web application routes";
    homepage = "https://github.com/mschwager/route-detect";
    changelog = "https://github.com/mschwager/route-detect/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "routes";
  };
}
