{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gogdl";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "heroic-gogdl";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-76bUTaMPB3/pzmuUCRO1LU8zDVWLD+NZ0uCbmKtejHc=";
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
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
})
