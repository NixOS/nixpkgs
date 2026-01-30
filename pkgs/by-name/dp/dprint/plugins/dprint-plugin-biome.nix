{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Biome (JS/TS/JSON) wrapper plugin";
  hash = "sha256-RQAApULPcEGBUeEUZsJic1yEkmP5XMzbzazfSc5e1uw=";
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
  url = "https://plugins.dprint.dev/biome-0.11.11.wasm";
  version = "0.11.11";
}
