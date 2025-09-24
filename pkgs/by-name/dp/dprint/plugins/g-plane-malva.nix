{ mkDprintPlugin }:
mkDprintPlugin {
  description = "CSS, SCSS, Sass and Less formatter";
  hash = "sha256-mFlhfqtglKtKNls96PO/2AWLL1fNC5msQCd9EgdKauE=";
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
  url = "https://plugins.dprint.dev/g-plane/malva-v0.11.2.wasm";
  version = "0.11.2";
}
