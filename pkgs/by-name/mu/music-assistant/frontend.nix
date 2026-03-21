{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "music-assistant-frontend";
  version = "2.17.73";
  pyproject = true;

  src = fetchPypi {
    pname = "music_assistant_frontend";
    inherit version;
    hash = "sha256-vmZa98pT5Cg22fa73/KTrMUqP4Axc1y4x710HCxBzIY=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "music_assistant_frontend" ];

  meta = {
    changelog = "https://github.com/music-assistant/frontend/releases/tag/${version}";
    description = "Music Assistant frontend";
    homepage = "https://github.com/music-assistant/frontend";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
