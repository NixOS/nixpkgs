{
  fetchFromGitHub,
  lib,
  python3Packages,
  ...
}:
python3Packages.buildPythonApplication rec {
  pname = "sncli";
  version = "0.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "insanum";
    repo = "sncli";
    rev = "0.4.4";
    hash = "sha256-Ldm8oQdJvZXjD2ZdnkK+HZjMkbDXGkJSkai3iuhNziw";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    urwid
    requests
    simperium3
    setuptools
  ];

  pythonImportsCheck = [ "simplenote_cli" ];

  # No tests available
  doCheck = false;

  meta = {
    homepage = "https://github.com/insanum/sncli";
    maintainers = with lib.maintainers; [ sigmonsays ];
    license = lib.licenses.mit;
    description = "Simplenote CLI";
    mainProgram = "sncli";
  };
}
