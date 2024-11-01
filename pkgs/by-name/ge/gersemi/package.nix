{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "gersemi";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "BlankSpruce";
    repo = "gersemi";
    rev = "refs/tags/${version}";
    hash = "sha256-t9W27lwNKRFAraynAGEawFb1qCW9/b3RCm/jeb9zJXg=";
  };

  propagatedBuildInputs = with python3Packages; [
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
