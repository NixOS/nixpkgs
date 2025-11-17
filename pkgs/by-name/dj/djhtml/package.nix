{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "djhtml";
  version = "3.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rtts";
    repo = "djhtml";
    tag = version;
    hash = "sha256-7K7/Zm6ORfza9AD+Jyl+0Q5zlxgF+WpH3a1O18VpT5k=";
  };

  build-system = [ python3Packages.setuptools ];

  pythonImportsCheck = [ "djhtml" ];

  meta = {
    homepage = "https://github.com/rtts/djhtml";
    description = "Django/Jinja template indenter";
    changelog = "https://github.com/rtts/djhtml/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "djhtml";
  };
}
