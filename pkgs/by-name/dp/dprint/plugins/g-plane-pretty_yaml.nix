{ mkDprintPlugin }:
mkDprintPlugin {
  description = "YAML formatter";
  hash = "sha256-QKL92nBAMX6xsjUg86AHaaVXHu2wScTKkXXBue66Aa4=";
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
  url = "https://plugins.dprint.dev/g-plane/pretty_yaml-v0.6.0.wasm";
  version = "0.6.0";
}
