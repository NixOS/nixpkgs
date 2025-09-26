{ mkDprintPlugin }:
mkDprintPlugin {
  description = "YAML formatter";
  hash = "sha256-6ua021G7ZW7Ciwy/OHXTA1Joj9PGEx3SZGtvaA//gzo=";
  initConfig = {
    configExcludes = [ ];
    configKey = "yaml";
    fileExtensions = [
      "yaml"
      "yml"
    ];
  };
  pname = "g-plane-pretty_yaml";
  updateUrl = "https://plugins.dprint.dev/g-plane/pretty_yaml/latest.json";
  url = "https://plugins.dprint.dev/g-plane/pretty_yaml-v0.5.0.wasm";
  version = "0.5.0";
}
