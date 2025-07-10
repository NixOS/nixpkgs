{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Biome (JS/TS) wrapper plugin.";
  hash = "sha256-QQ4FrQL64JJ/JJNWt6i5+2yqM15TXICcKGTqUDEWVVA=";
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
  url = "https://plugins.dprint.dev/biome-0.9.0.wasm";
  version = "0.9.0";
}
