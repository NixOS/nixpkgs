{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-azuretools";
    name = "vscode-containers";
    version = "2.0.3";
    hash = "sha256-MAeE99XmjIjYbr72UymnkrDKsNRSjNiB1jdffKTosHQ=";
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
