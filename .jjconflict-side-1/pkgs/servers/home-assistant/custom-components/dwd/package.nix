{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  defusedxml,
}:

buildHomeAssistantComponent rec {
  owner = "hg1337";
  domain = "dwd";
  version = "2026.2.0";

  src = fetchFromGitHub {
    owner = "hg1337";
    repo = "homeassistant-dwd";
    rev = version;
    hash = "sha256-dH2TRNInfbZWS0IlNtAsL4Cxg2fCtopgFILUCyNz4NE=";
  };

  dependencies = [ defusedxml ];

  # defusedxml version mismatch
  dontCheckManifest = true;

  meta = {
    description = "Custom component for Home Assistant that integrates weather data (measurements and forecasts) of Deutscher Wetterdienst";
    homepage = "https://github.com/hg1337/homeassistant-dwd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      hexa
      emilylange
    ];
  };
}
