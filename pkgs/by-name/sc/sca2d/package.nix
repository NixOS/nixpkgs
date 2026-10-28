{
  lib,
  python3Packages,
  fetchFromGitLab,
}:
python3Packages.buildPythonApplication rec {
  pname = "sca2d";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "bath_open_instrumentation_group";
    repo = "sca2d";
    tag = "v${version}";
    hash = "sha256-fXZndNkG8JtPfK1smNoCjUdxLGYMuNpYUoyQOfLelrs=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    lark
    colorama
    pygments
    jinja2
    markdown
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  disabledTestPaths = [
    # Requires network access to clone the OpenFlexure Microscope repository
    "tests/integration_test.py"
  ];

  pythonImportsCheck = [ "sca2d" ];

  meta = {
    description = "Experimental static code analyser for OpenSCAD";
    mainProgram = "sca2d";
    homepage = "https://gitlab.com/bath_open_instrumentation_group/sca2d";
    changelog = "https://gitlab.com/bath_open_instrumentation_group/sca2d/-/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ traxys ];
  };
}
