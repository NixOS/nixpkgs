{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Biome (JS/TS) wrapper plugin";
  hash = "sha256-Ht63tW4FqykpuNlWtyw3cHD2HXs0b6U6Zo9Rd9AXqD8=";
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
  url = "https://plugins.dprint.dev/biome-0.10.6.wasm";
  version = "0.10.6";
}
