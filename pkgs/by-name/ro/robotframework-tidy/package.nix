{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "robotframework-tidy";
  version = "4.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = "robotframework-tidy";
    tag = version;
    hash = "sha256-R/IfIM1bL622HLfxgoIV9iPb6QG/VkXx/hRhtTdxpCo=";
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
