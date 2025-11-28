{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Biome (JS/TS) wrapper plugin";
  hash = "sha256-V8lXwGRWGvl/g2kjqL8Ei1N7V0nuTP2WcLFWJvC7D+A=";
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
  url = "https://plugins.dprint.dev/biome-0.11.6.wasm";
  version = "0.11.6";
}
