{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  ulid-transform,
}:

buildHomeAssistantComponent rec {
  owner = "basnijholt";
  domain = "adaptive_lighting";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "basnijholt";
    repo = "adaptive-lighting";
    rev = "refs/tags/${version}";
    hash = "sha256-Yq8mKk2j2CHyHvwyej0GeFQhuy1MFXwt0o+lDOGwrBU=";
  };

  propagatedBuildInputs = [
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
