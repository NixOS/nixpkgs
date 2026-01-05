{ mkDprintPlugin }:
mkDprintPlugin {
  description = "TOML code formatter";
  hash = "sha256-ASbIESaRVC0wtSpjkHbsyD4Hus6HdjjO58aRX9Nrhik=";
  initConfig = {
    configExcludes = [ ];
    configKey = "toml";
    fileExtensions = [ "toml" ];
  };
  pname = "dprint-plugin-toml";
  updateUrl = "https://plugins.dprint.dev/dprint/toml/latest.json";
  url = "https://plugins.dprint.dev/toml-0.7.0.wasm";
  version = "0.7.0";
}
