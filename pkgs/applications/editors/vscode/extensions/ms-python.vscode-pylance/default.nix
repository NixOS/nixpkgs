{
  lib,
  pyright,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-pylance";
    publisher = "MS-python";
    version = "2026.1.1";
    hash = "sha256-82zIUJBgjbBW0R6ExBLXGYYtYxm1vC7bz/3BvP3IIXA=";
  };

  buildInputs = [ pyright ];

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/ms-python.vscode-pylance/changelog";
    description = "Performant, feature-rich language server for Python in VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance";
    homepage = "https://github.com/microsoft/pylance-release";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
