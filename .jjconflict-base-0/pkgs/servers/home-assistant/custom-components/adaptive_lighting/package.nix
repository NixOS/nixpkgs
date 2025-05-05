{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  ulid-transform,
}:

buildHomeAssistantComponent rec {
  owner = "basnijholt";
  domain = "adaptive_lighting";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "basnijholt";
    repo = "adaptive-lighting";
    tag = "v${version}";
    hash = "sha256-ykliUi/gnJB9hMNI72RCofcGzS7799lVTAXZyrho/Ng=";
  };

  dependencies = [
    ulid-transform
  ];

  meta = with lib; {
    changelog = "https://github.com/basnijholt/adaptive-lighting/releases/tag/${version}";
    description = "Home Assistant Adaptive Lighting Plugin - Sun Synchronized Lighting";
    homepage = "https://github.com/basnijholt/adaptive-lighting";
    maintainers = with maintainers; [ mindstorms6 ];
    license = licenses.asl20;
  };
}
