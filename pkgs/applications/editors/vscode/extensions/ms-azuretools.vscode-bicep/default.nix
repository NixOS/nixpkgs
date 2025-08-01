{
  azure-cli,
  bicep,
  bicep-lsp,
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-azuretools";
    name = "vscode-bicep";
    version = "0.36.1";
    hash = "sha256-yrSIHTGHZ1m6fLGrtVlT4UHyWpKuzGKdywBDsMepd4g=";
  };

  buildInputs = [
    azure-cli
    bicep
    bicep-lsp
  ];

  meta = {
    description = "Visual Studio Code extension for Bicep language";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep";
    homepage = "https://github.com/Azure/bicep/tree/main/src/vscode-bicep";
    license = lib.licenses.mit;
    teams = [ lib.teams.stridtech ];
  };
}

# Instructions on Usage
#
# programs.vscode = {
#  enable = true;
#  package = pkgs.codium;
#  profiles.default = {
#    "dotnetAcquisitionExtension.sharedExistingDotnetPath" = "${pkgs.dotnet-sdk_8}/bin/dotnet";
#    "dotnetAcquisitionExtension.existingDotnetPath" = [
#       {
#          "extensionId" = "ms-dotnettools.csharp";
#          "path" = "${pkgs.dotnet-sdk_8}/bin/dotnet";
#       }
#       {
#          "extensionId" = "ms-dotnettools.csdevkit";
#          "path" = "${pkgs.dotnet-sdk_8}/bin/dotnet";
#       }
#       {
#          "extensionId" = "ms-azuretools.vscode-bicep";
#          "path" = "${pkgs.dotnet-sdk_8}/bin/dotnet";
#       }
#    ];
#  extensions = with pkgs.vscode-extensions; [
#    ms-azuretools.vscode-bicep
#    ms-dotnettools.csdevkit
#    ms-dotnettools.csharp
#    ms-dotnettools.vscode-dotnet-runtime
#  ];
# };
