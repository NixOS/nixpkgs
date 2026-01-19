{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rassumfrassum";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joaotavora";
    repo = "rassumfrassum";
    rev = "v${version}";
    hash = "sha256-FFQawil0JRTp3bfBWq8mypkCMiHuxozyblVcTBToTso=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  pythonImportsCheck = [
    "rassumfrassum"
  ];

  meta = {
    description = "LSP multiplexer";
    homepage = "https://github.com/joaotavora/rassumfrassum";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ feyorsh ];
    mainProgram = "rassumfrassum";
  };
}
