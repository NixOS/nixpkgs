{ mkDprintPlugin }:
mkDprintPlugin {
  description = "TypeScript/JavaScript code formatter";
  hash = "sha256-01MkexYMHoHrBDkw3m+UCtzT1xNlEiHToChNTDDqQ8Q=";
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
  url = "https://plugins.dprint.dev/typescript-0.95.13.wasm";
  version = "0.95.13";
}
