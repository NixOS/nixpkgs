{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "gersemi";
  version = "0.23.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "BlankSpruce";
    repo = "gersemi";
    tag = version;
    hash = "sha256-sXgu3KscRi/3Myg/4jarMZ4W7/CaQTmyxxbcu8/0o6Y=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    appdirs
    colorama
    lark
    pyyaml
  ];

  meta = {
    description = "Formatter to make your CMake code the real treasure";
    homepage = "https://github.com/BlankSpruce/gersemi";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ xeals ];
    mainProgram = "gersemi";
  };
}
