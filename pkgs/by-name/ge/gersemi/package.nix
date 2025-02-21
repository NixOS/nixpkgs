{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "gersemi";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "BlankSpruce";
    repo = "gersemi";
    rev = version;
    hash = "sha256-MyiGmMITD6TlZ98qsSDalQWOWnpqelTrXKn6MmBGYS0=";
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
