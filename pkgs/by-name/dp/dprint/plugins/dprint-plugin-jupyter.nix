{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Jupyter notebook code block formatter";
  hash = "sha256-IlGwt2TnKeH9NwmUmU1keaTInXgYQVLIPNnr30A9lsM=";
  initConfig = {
    configExcludes = [ ];
    configKey = "jupyter";
    fileExtensions = [ "ipynb" ];
  };
  pname = "dprint-plugin-jupyter";
  updateUrl = "https://plugins.dprint.dev/dprint/jupyter/latest.json";
  url = "https://plugins.dprint.dev/jupyter-0.2.0.wasm";
  version = "0.2.0";
}
