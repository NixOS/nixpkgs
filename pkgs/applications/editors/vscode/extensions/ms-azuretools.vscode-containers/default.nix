{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-azuretools";
    name = "vscode-containers";
    version = "2.4.2";
    hash = "sha256-qkQAv53y+PVKJdReffjHwoJbvj20o4DF/c6omLIWB80=";
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
