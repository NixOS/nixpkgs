{ mkDprintPlugin }:
mkDprintPlugin {
  description = "Jupyter notebook code block formatter";
  hash = "sha256-7qM9MTTvvuPfx3WScO3jR0GEb8L0kHg24BJLsJYBiZg=";
  initConfig = {
    configExcludes = [ ];
    configKey = "jupyter";
    fileExtensions = [ "ipynb" ];
  };
  pname = "dprint-plugin-jupyter";
  updateUrl = "https://plugins.dprint.dev/dprint/jupyter/latest.json";
  url = "https://plugins.dprint.dev/jupyter-0.2.1.wasm";
  version = "0.2.1";
}
