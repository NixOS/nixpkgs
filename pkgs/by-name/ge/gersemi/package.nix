{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "gersemi";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "BlankSpruce";
    repo = "gersemi";
    tag = version;
    hash = "sha256-lQafcZLTF/6SHC/NL1UnuilascjwqH4sX+kmCYHFDrw=";
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
