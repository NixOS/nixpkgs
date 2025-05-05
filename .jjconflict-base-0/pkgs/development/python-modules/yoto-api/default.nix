{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytz,
  requests,
  paho-mqtt,
}:

buildPythonPackage rec {
  pname = "yoto-api";
  version = "1.24.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cdnninja";
    repo = "yoto_api";
    tag = "v${version}";
    hash = "sha256-zgyZpya67cmJb2tz7Ht8G4y78UejVF00kssasZ8F+58=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pytz
    requests
    paho-mqtt
  ];

  # All tests require access to and authentication with the Yoto API (api.yotoplay.com).
  doCheck = false;

  pythonImportsCheck = [ "yoto_api" ];

  meta = with lib; {
    changelog = "https://github.com/cdnninja/yoto_api/releases/tag/${src.tag}";
    homepage = "https://github.com/cdnninja/yoto_api";
    platforms = platforms.unix;
    maintainers = with maintainers; [ seberm ];
    license = licenses.mit;
    description = "A python package that makes it a bit easier to work with the yoto play API.";
  };
}
