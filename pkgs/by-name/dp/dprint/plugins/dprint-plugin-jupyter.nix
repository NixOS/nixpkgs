{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Jupyter notebook code block formatter.";
  hash = "sha256-877CEZbMlj9cHkFtl16XCnan37SeEGUL3BHaUKUv8S4=";
  initConfig = {
    configExcludes = [ ];
    configKey = "jupyter";
    fileExtensions = [ "ipynb" ];
  };
  pname = "dprint-plugin-jupyter";
  updateUrl = "https://plugins.dprint.dev/dprint/jupyter/latest.json";
  url = "https://plugins.dprint.dev/jupyter-0.1.5.wasm";
  version = "0.1.5";
}
