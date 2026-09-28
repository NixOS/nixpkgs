{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-python";
    name = "pylint";
    version = "2026.6.0";
    hash = "sha256-lJl+nQyLjnkuMfewYXcrU+Nne7R2foUPn50TtE9OqDA=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/ms-python.pylint/changelog";
    description = "Python linting support for VS Code using Pylint";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.pylint";
    homepage = "https://github.com/microsoft/vscode-pylint";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
