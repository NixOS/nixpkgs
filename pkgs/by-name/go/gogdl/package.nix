{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gogdl";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "heroic-gogdl";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-tTd41ufxPObXwLpA1F0HXNEROnJwHt4WpojsRnNLml0=";
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
})
