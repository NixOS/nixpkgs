{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Oxc (JS/TS) wrapper plugin";
  hash = "sha256-BctJI87x82s3gpCovPSbGp+PfdBuYRZnXeCWWyFHpRs=";
  initConfig = {
    configExcludes = [ "**/node_modules" ];
    configKey = "oxc";
    fileExtensions = [
      "ts"
      "tsx"
      "js"
      "jsx"
      "cjs"
      "mjs"
    ];
  };
  pname = "dprint-plugin-oxc";
  updateUrl = "https://plugins.dprint.dev/dprint/oxc/latest.json";
  url = "https://plugins.dprint.dev/oxc-0.2.0.wasm";
  version = "0.2.0";
}
