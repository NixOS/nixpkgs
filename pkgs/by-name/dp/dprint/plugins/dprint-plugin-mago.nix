{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Mago (PHP) wrapper plugin";
  hash = "sha256-QnQ82e+AGqVCJQiMqYOxGl9vDwnqTCu6aFRwOK39QTM=";
  initConfig = {
    configExcludes = [ ];
    configKey = "mago";
    fileExtensions = [ "php" ];
  };
  pname = "dprint-plugin-mago";
  updateUrl = "https://plugins.dprint.dev/dprint/mago/latest.json";
  url = "https://plugins.dprint.dev/mago-0.0.1.wasm";
  version = "0.0.1";
}
