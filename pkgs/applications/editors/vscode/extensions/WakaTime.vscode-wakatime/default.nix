{ lib
, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-wakatime";
      publisher = "WakaTime";
      version = "18.0.5";
      sha256 = "sha256-vWqGxMbxKqd4UgKK0sOKadMTDf6Y3TQxfWsc93MHjFs=";
    };

    meta = {
      description = ''
        Visual Studio Code plugin for automatic time tracking and metrics generated
        from your programming activity
      '';
      license = lib.licenses.bsd3;
    };
  }
