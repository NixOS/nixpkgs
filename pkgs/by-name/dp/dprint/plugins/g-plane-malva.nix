{ mkDprintPlugin }:
mkDprintPlugin {
  description = "CSS, SCSS, Sass and Less formatter";
  hash = "sha256-IAIix6c9/GNDZsRk95T/rpvMh7HqFgBoq5KDVYHHOjU=";
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
  url = "https://plugins.dprint.dev/g-plane/malva-v0.14.3.wasm";
  version = "0.14.3";
}
