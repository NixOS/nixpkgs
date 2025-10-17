{ mkDprintPlugin }:
mkDprintPlugin {
  description = "JSON/JSONC code formatter";
  hash = "sha256-uFcFLi9aYsBrAqkhFmg9GI+LKiV19LxdNjxQ85EH9To=";
  initConfig = {
    configExcludes = [ "**/*-lock.json" ];
    configKey = "json";
    fileExtensions = [ "json" ];
  };
  pname = "dprint-plugin-json";
  updateUrl = "https://plugins.dprint.dev/dprint/json/latest.json";
  url = "https://plugins.dprint.dev/json-0.20.0.wasm";
  version = "0.20.0";
}
