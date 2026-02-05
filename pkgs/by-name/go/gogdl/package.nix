{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gogdl";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "heroic-gogdl";
    # two commits after the v1.2.0 tag, because the release messed up submodule fetching
    rev = "9759dfb1f50e0c68854f938e9568d84cab59652c";
    fetchSubmodules = true;
    hash = "sha256-yjiPHEiZjs9TnBRaKzm1TpLcPK0tfIrzM30DX66m+1Y=";
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
