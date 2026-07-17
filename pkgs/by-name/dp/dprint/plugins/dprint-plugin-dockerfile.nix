{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Dockerfile code formatter";
  hash = "sha256-GaK1sYdZPwQWJmz2ULcsGpWDiKjgPhqNRoGgQfGOkqc=";
  initConfig = {
    configExcludes = [ ];
    configKey = "dockerfile";
    fileExtensions = [ "dockerfile" ];
  };
  pname = "dprint-plugin-dockerfile";
  updateUrl = "https://plugins.dprint.dev/dprint/dockerfile/latest.json";
  url = "https://plugins.dprint.dev/dockerfile-0.3.3.wasm";
  version = "0.3.3";
}
