{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-azuretools";
    name = "vscode-containers";
    version = "2.3.0";
    hash = "sha256-zrEZpd2geX2G4u6LkIk3d6C7vhwZZ4lwHGQR3Z0OWY4=";
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
