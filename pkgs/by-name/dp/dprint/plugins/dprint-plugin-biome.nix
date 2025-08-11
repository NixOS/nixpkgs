{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Biome (JS/TS) wrapper plugin";
  hash = "sha256-6F1yeyZo5eeOudPFMFepez2ridvgMywydVKxB997D+A=";
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
  url = "https://plugins.dprint.dev/biome-0.9.2.wasm";
  version = "0.9.2";
}
