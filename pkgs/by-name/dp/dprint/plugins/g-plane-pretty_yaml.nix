{ mkDprintPlugin }:
mkDprintPlugin {
  description = "YAML formatter";
  hash = "sha256-iSh5SRrjQB1hJoKkkup7R+Durcu+cxePa7GDVjwnexU=";
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
  url = "https://plugins.dprint.dev/g-plane/pretty_yaml-v0.5.1.wasm";
  version = "0.5.1";
}
