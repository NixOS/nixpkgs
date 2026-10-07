{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "win2xcur";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "quantum5";
    repo = "win2xcur";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zr3zLbjbQAY7McoF89W2Dqgj49mpHDZZBS9zzhqTAm8=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    numpy
    wand
  ];

  pythonImportsCheck = [
    "win2xcur.main.inspectcur"
    "win2xcur.main.win2xcur"
    "win2xcur.main.win2xcurtheme"
    "win2xcur.main.x2wincur"
    "win2xcur.main.x2wincurtheme"
  ];

  meta = {
    description = "Tools that convert cursors between the Windows (*.cur, *.ani) and Xcursor format";
    homepage = "https://github.com/quantum5/win2xcur";
    changelog = "https://github.com/quantum5/win2xcur/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ teatwig ];
  };
})
