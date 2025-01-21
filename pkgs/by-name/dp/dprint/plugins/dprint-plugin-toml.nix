{ mkDprintPlugin }:
mkDprintPlugin {
  description = "TOML code formatter.";
  hash = "sha256-aDfo/sKfOeNpyfd/4N1LgL1bObTTnviYrA8T7M/1KNs=";
  initConfig = {
    configExcludes = [ ];
    configKey = "toml";
    fileExtensions = [ "toml" ];
  };
  pname = "dprint-plugin-toml";
  updateUrl = "https://plugins.dprint.dev/dprint/toml/latest.json";
  url = "https://plugins.dprint.dev/toml-0.6.3.wasm";
  version = "0.6.3";
}
