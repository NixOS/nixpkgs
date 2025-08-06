{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "music-assistant-frontend";
  version = "2.15.1";
  pyproject = true;

  src = fetchPypi {
    pname = "music_assistant_frontend";
    inherit version;
    hash = "sha256-l6SKBMqP2FrjVUmywDXf0I4Te0qbzufUVR7frWAzrks=";
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
