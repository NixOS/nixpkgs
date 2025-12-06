{ lib, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-wakatime";
    publisher = "WakaTime";
    version = "25.5.0";
    hash = "sha256-IijI2mTdytFZ7qRpS8WefrPSUvO9H8HTUFpHTsFgQdI=";
  };

  meta = {
    description = ''
      Visual Studio Code plugin for automatic time tracking and metrics generated
      from your programming activity
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ cizniarova ];
  };
}
