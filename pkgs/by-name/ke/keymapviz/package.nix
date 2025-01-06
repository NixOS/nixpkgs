{
  fetchFromGitHub,
  lib,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "keymapviz";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "yskoht";
    repo = pname;
    rev = version;
    sha256 = "sha256-eCvwgco22uPEDDsT8FfTRon1xCGy5p1PBp0pDfNprMs=";
  };

  propagatedBuildInputs = with python3.pkgs; [ regex ];

  meta = {
    description = "Qmk keymap.c visualizer";
    homepage = "https://github.com/yskoht/keymapviz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lom ];
    mainProgram = "keymapviz";
  };
}
