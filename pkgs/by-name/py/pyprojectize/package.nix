{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pyprojectize";
  version = "1a7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hroncok";
    repo = "pyprojectize";
    tag = version;
    hash = "sha256-MVA8Mx+jpPrNB099BfAxGBfZWyvFTYR8q0vyspj7jSY=";
  };

  build-system = with python3.pkgs; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python3.pkgs; [
    packaging
    specfile
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "pyprojectize" ];

  meta = {
    description = "Tool to convert a RPM spec file from %py3_build etc. macros to pyproject";
    homepage = "https://github.com/hroncok/pyprojectize";
    changelog = "https://github.com/hroncok/pyprojectize/releases/tag/${src.tag}";
    license = lib.licenses.mit0;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pyprojectize";
  };
}
