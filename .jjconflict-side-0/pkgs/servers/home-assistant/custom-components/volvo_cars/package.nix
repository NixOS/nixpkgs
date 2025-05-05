{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "thomasddn";
  domain = "volvo_cars";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "thomasddn";
    repo = "ha-volvo-cars";
    tag = "v${version}";
    hash = "sha256-UG/anp9ThEOQsRWraTayuyx6kS9r2vTH/8Bak4ZzYzo";
  };

  meta = with lib; {
    changelog = "https://github.com/thomasddn/ha-volvo-cars/releases/tag/${src.tag}";
    homepage = "https://github.com/thomasddn/ha-volvo-cars";
    description = "Volvo Cars Home Assistant integration";
    maintainers = with maintainers; [ seberm ];
    license = licenses.gpl3Only;
  };
}
