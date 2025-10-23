{ mkDprintPlugin }:
mkDprintPlugin {
  description = "JSON/JSONC code formatter";
  hash = "sha256-GIoIkW7szyQU4GyLUdj0TTaV8FWg1jzvOerOChHiR7w=";
  initConfig = {
    configExcludes = [ "**/*-lock.json" ];
    configKey = "json";
    fileExtensions = [ "json" ];
  };
  pname = "dprint-plugin-json";
  updateUrl = "https://plugins.dprint.dev/dprint/json/latest.json";
  url = "https://plugins.dprint.dev/json-0.21.0.wasm";
  version = "0.21.0";
}
