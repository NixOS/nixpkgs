{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-azuretools";
    name = "vscode-containers";
    version = "2.5.0";
    hash = "sha256-NYYI2w5N8PEPeFcO1PHtD6hinK6Rb6Ux6Ot8OYxYydU=";
  };

  meta = {
    changelog = "https://github.com/microsoft/vscode-containers/releases";
    description = "Container Tools Extension for Visual Studio Code ";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers";
    homepage = "https://github.com/microsoft/vscode-containers";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.m0nsterrr ];
  };
}
