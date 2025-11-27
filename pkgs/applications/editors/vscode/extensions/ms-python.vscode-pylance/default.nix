{
  lib,
  pyright,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-pylance";
    publisher = "MS-python";
    version = "2025.10.2";
    hash = "sha256-4oyS5Y/NE9k3xOKzT88CpB5fXoANqIAIl9GhjZWUAsE=";
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
