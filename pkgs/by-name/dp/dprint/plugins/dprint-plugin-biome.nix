{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Biome (JS/TS/JSON) wrapper plugin";
  hash = "sha256-dcM4Z9QP0B+gp2MnQxTfjIykPYZdwPuKnQRjjpL5DV8=";
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
  url = "https://plugins.dprint.dev/biome-0.12.5.wasm";
  version = "0.12.5";
}
