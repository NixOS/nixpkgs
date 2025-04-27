{ lib, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-wakatime";
    publisher = "WakaTime";
    version = "25.0.1";
    hash = "sha256-4Q/38zO8G39oeZh4N9hOSFBeB0rI7ouH5vlBmV78EnQ=";
  };

  meta = {
    description = ''
      Visual Studio Code plugin for automatic time tracking and metrics generated
      from your programming activity
    '';
    license = lib.licenses.bsd3;
  };
}
