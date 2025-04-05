{ mkDprintPlugin }:
mkDprintPlugin {
  description = "TypeScript/JavaScript code formatter.";
  hash = "sha256-/N6TH5hYsTHJcBWwpz874EDRxBv+SRhyPO8IyN5dzDU=";
  initConfig = {
    configExcludes = [ "**/node_modules" ];
    configKey = "typescript";
    fileExtensions = [
      "ts"
      "tsx"
      "js"
      "jsx"
      "cjs"
      "mjs"
    ];
  };
  pname = "dprint-plugin-typescript";
  updateUrl = "https://plugins.dprint.dev/dprint/typescript/latest.json";
  url = "https://plugins.dprint.dev/typescript-0.94.0.wasm";
  version = "0.94.0";
}
