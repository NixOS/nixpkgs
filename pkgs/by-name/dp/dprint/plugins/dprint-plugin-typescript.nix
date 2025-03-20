{ mkDprintPlugin }:
mkDprintPlugin {
  description = "TypeScript/JavaScript code formatter.";
  hash = "sha256-urgKQOjgkoDJCH/K7DWLJCkD0iH0Ok+rvrNDI0i4uS0=";
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
  url = "https://plugins.dprint.dev/typescript-0.93.3.wasm";
  version = "0.93.3";
}
