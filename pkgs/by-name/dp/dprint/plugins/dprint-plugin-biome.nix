{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Biome (JS/TS/JSON) wrapper plugin";
  hash = "sha256-EZg0l50VGrEDGKEMX64d7EzvdO3+tQfCtTIJp8JUYX4=";
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
  url = "https://plugins.dprint.dev/biome-0.12.1.wasm";
  version = "0.12.1";
}
