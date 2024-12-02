{ lib, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-wakatime";
    publisher = "WakaTime";
    version = "24.2.0";
    hash = "sha256-1AAerJsgmXJGiEOlxQRRo00JxYBm1Y8xI4rMQUcdv6k=";
  };

  meta = {
    description = ''
      Visual Studio Code plugin for automatic time tracking and metrics generated
      from your programming activity
    '';
    license = lib.licenses.bsd3;
  };
}
