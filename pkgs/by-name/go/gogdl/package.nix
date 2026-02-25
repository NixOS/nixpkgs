{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "gogdl";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "heroic-gogdl";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-qYarDcwrVrTpLHQYdWQvXL5+V1wMyL06+n5t6LXKBHI=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    requests
  ];

  pythonImportsCheck = [ "gogdl" ];

  meta = {
    description = "GOG Downloading module for Heroic Games Launcher";
    mainProgram = "gogdl";
    homepage = "https://github.com/Heroic-Games-Launcher/heroic-gogdl";
    license = with lib.licenses; [ gpl3 ];
    maintainers = [ ];
  };
}
