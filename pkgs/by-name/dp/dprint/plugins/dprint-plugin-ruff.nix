{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Ruff (Python) wrapper plugin";
  hash = "sha256-15InHQgF9c0Js4yUJxmZ1oNj1O16FBU12u/GOoaSAJ8=";
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
  url = "https://plugins.dprint.dev/ruff-0.3.9.wasm";
  version = "0.3.9";
}
