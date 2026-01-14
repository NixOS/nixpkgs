{ mkDprintPlugin }:
mkDprintPlugin {
  description = "CSS, SCSS, Sass and Less formatter";
  hash = "sha256-6ioZNF6j8y0ObHbPdNrjz3eH+WMQdry4s624eTDLnX8=";
  initConfig = {
    configExcludes = [ "**/node_modules" ];
    configKey = "malva";
    fileExtensions = [
      "css"
      "scss"
      "sass"
      "less"
    ];
  };
  pname = "g-plane-malva";
  updateUrl = "https://plugins.dprint.dev/g-plane/malva/latest.json";
  url = "https://plugins.dprint.dev/g-plane/malva-v0.15.1.wasm";
  version = "0.15.1";
}
