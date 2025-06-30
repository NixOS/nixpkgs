{ lib, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-wakatime";
    publisher = "WakaTime";
    version = "25.0.6";
    hash = "sha256-arBd8ihYlyGPm0mrRnGJNzuhQmMqADH7TrqCwMR7R/U=";
  };

  meta = {
    description = ''
      Visual Studio Code plugin for automatic time tracking and metrics generated
      from your programming activity
    '';
    license = lib.licenses.bsd3;
  };
}
