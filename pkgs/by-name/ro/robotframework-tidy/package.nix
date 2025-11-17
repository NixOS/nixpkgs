{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "robotframework-tidy";
  version = "4.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = "robotframework-tidy";
    tag = version;
    hash = "sha256-WAuB+kTEZAG1uVEXVY1CdIDGeRRHo5AT1bHs8/wBBcc=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  pythonRelaxDeps = [ "rich_click" ];

  dependencies = with python3.pkgs; [
    robotframework
    click
    colorama
    pathspec
    tomli
    rich-click
    jinja2
    tomli-w
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  meta = {
    description = "Code autoformatter for Robot Framework";
    homepage = "https://robotidy.readthedocs.io";
    changelog = "https://github.com/MarketSquare/robotframework-tidy/blob/main/docs/releasenotes/${src.tag}.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "robotidy";
  };
}
