<<<<<<< HEAD
{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-wakatime";
    publisher = "WakaTime";
    version = "25.4.0";
    hash = "sha256-furuRhQPcK9r4G878WKD9BiQuiwRbn+pJpNWAbpIgOw=";
=======
{ lib, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-wakatime";
    publisher = "WakaTime";
    version = "25.3.2";
    hash = "sha256-xX1vejS8zoidcI6fnp7vvtSw4rMHIe2IF4JQJB5hvqs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
