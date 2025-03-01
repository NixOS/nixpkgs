{ mkDprintPlugin }:
mkDprintPlugin {
  description = "JSON/JSONC code formatter.";
  hash = "sha256-Sw+HkUb4K2wrLuQRZibr8gOCR3Rz36IeId4Vd4LijmY=";
  initConfig = {
    configExcludes = [ "**/*-lock.json" ];
    configKey = "json";
    fileExtensions = [ "json" ];
  };
  pname = "dprint-plugin-json";
  updateUrl = "https://plugins.dprint.dev/dprint/json/latest.json";
  url = "https://plugins.dprint.dev/json-0.19.4.wasm";
  version = "0.19.4";
}
