{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Biome (JS/TS/JSON) wrapper plugin";
  hash = "sha256-LaByLZ0y+/kqo2+Yfk0WD6/DMUaS9vkkqnTCQwKwujY=";
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
  url = "https://plugins.dprint.dev/biome-0.11.13.wasm";
  version = "0.11.13";
}
