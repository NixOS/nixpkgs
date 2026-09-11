{
  fetchFromGitHub,
  lib,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "keymapviz";
  version = "1.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yskoht";
    repo = "keymapviz";
    rev = finalAttrs.version;
    sha256 = "sha256-eCvwgco22uPEDDsT8FfTRon1xCGy5p1PBp0pDfNprMs=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ regex ];

  pythonImportsCheck = [ "keymapviz" ];

  meta = {
    description = "Qmk keymap.c visualizer";
    homepage = "https://github.com/yskoht/keymapviz";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "keymapviz";
  };
})
