{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Biome (JS/TS/JSON) wrapper plugin";
  hash = "sha256-oVhS76n0SVoSrheKv3ynpKKS7s4Zj1s2ER3FaG8r4WM=";
  initConfig = {
    configExcludes = [ "**/node_modules" ];
    configKey = "biome";
    fileExtensions = [
      "ts"
      "tsx"
      "js"
      "jsx"
      "cjs"
      "mjs"
      "json"
    ];
  };
  pname = "dprint-plugin-biome";
  updateUrl = "https://plugins.dprint.dev/dprint/biome/latest.json";
  url = "https://plugins.dprint.dev/biome-0.11.14.wasm";
  version = "0.11.14";
}
