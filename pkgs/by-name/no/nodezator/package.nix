{
  lib,
  python3Packages,
  fetchPypi,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "nodezator";
  version = "1.5.3";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generalist Python node editor";
    homepage = "https://nodezator.com";
    downloadPage = "https://github.com/IndiePython/nodezator";
    changelog = "https://github.com/IndiePython/nodezator/releases/tag/v${version}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "nodezator";
  };
}
