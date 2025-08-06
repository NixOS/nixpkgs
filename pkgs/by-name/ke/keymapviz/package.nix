{
  fetchFromGitHub,
  lib,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "keymapviz";
  version = "1.14.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "yskoht";
    repo = "keymapviz";
    rev = version;
    sha256 = "sha256-eCvwgco22uPEDDsT8FfTRon1xCGy5p1PBp0pDfNprMs=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ regex ];

  pythonImportsCheck = [ "keymapviz" ];

  meta = with lib; {
    description = "Qmk keymap.c visualizer";
    homepage = "https://github.com/yskoht/keymapviz";
    license = licenses.mit;
    maintainers = with maintainers; [ lom ];
    mainProgram = "keymapviz";
  };
}
