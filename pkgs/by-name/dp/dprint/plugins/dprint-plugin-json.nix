{ mkDprintPlugin }:
mkDprintPlugin {
  description = "JSON/JSONC code formatter";
  hash = "sha256-CetVbLXlgZcrBs6yxFNqkK4DK4TThL7qiDfJkYhFTN8=";
  initConfig = {
    configExcludes = [ "**/*-lock.json" ];
    configKey = "json";
    fileExtensions = [ "json" ];
  };
  pname = "dprint-plugin-json";
  updateUrl = "https://plugins.dprint.dev/dprint/json/latest.json";
  url = "https://plugins.dprint.dev/json-0.21.1.wasm";
  version = "0.21.1";
}
