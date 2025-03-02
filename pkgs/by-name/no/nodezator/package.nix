{
  lib,
  python3Packages,
  fetchPypi,
}:
let
  pname = "nodezator";
  version = "1.5.3";
in
python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qa7OWKoc45/giFHX6j9SGwQwWvLYfBDfMD09oiVfZUQ=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pygame-ce
    numpy
  ];

  meta = {
    description = "Generalist Python node editor";
    homepage = "https://nodezator.com";
    changelog = "https://github.com/IndiePython/nodezator/releases";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "nodezator";
  };
}
