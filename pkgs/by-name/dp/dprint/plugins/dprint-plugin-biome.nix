{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Biome (JS/TS) wrapper plugin";
  hash = "sha256-6UIeTsS5ovtH79gP4PGn0ePttqr4Vuo+RgXTk+jSZjE=";
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
    ];
  };
  pname = "dprint-plugin-biome";
  updateUrl = "https://plugins.dprint.dev/dprint/biome/latest.json";
  url = "https://plugins.dprint.dev/biome-0.11.4.wasm";
  version = "0.11.4";
}
