{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  json-timeseries,
  openplantbook-sdk,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "olen";
  domain = "openplantbook";
  version = "1.7.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "home-assistant-openplantbook";
    tag = "v${version}";
    hash = "sha256-Z5A87rAeSWHnAb8iO2uG7NOG+vdGSC5jgVuhEP57nYk=";
  };

  ignoreVersionRequirement = [
    "json-timeseries"
    "openplantbook-sdk"
  ];

  dependencies = [
    json-timeseries
    openplantbook-sdk
  ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  meta = {
    description = "Integration to search and fetch data from Openplantbook.io";
    homepage = "https://github.com/Olen/home-assistant-openplantbook";
    changelog = "https://github.com/Olen/home-assistant-openplantbook/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.gpl3Only;
  };
}
