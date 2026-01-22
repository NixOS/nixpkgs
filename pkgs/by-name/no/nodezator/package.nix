{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "nodezator";
  version = "1.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IndieSmiths";
    repo = "nodezator";
    tag = "v${version}";
    hash = "sha256-kdkOAJB7cVaayJOzof7dV9EBczEoEKXzCM7TcY8Ex5g=";
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
