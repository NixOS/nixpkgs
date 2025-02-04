{ mkDprintPlugin }:
mkDprintPlugin {
  description = "CSS, SCSS, Sass and Less formatter.";
  hash = "sha256-zt7F1tgPhPAn+gtps6+JB5RtvjIZw2n/G85Bv6kazgU=";
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
  url = "https://plugins.dprint.dev/g-plane/malva-v0.11.1.wasm";
  version = "0.11.1";
}
