{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Ruff (Python) wrapper plugin";
  hash = "sha256-qT+6zPbX3KrONXshwzLoGTWRXM93VKO0lN9ycJujEDM=";
  initConfig = {
    configExcludes = [ ];
    configKey = "ruff";
    fileExtensions = [
      "py"
      "pyi"
    ];
  };
  pname = "dprint-plugin-ruff";
  updateUrl = "https://plugins.dprint.dev/dprint/ruff/latest.json";
  url = "https://plugins.dprint.dev/ruff-0.6.1.wasm";
  version = "0.6.1";
}
