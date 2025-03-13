{ mkDprintPlugin }:
mkDprintPlugin {
  description = "TOML code formatter.";
  hash = "sha256-4g/nu8Wo7oF+8OAyXOzs9MuGpt2RFGvD58Bafnrr3ZQ=";
  initConfig = {
    configExcludes = [ ];
    configKey = "toml";
    fileExtensions = [ "toml" ];
  };
  pname = "dprint-plugin-toml";
  updateUrl = "https://plugins.dprint.dev/dprint/toml/latest.json";
  url = "https://plugins.dprint.dev/toml-0.6.4.wasm";
  version = "0.6.4";
}
