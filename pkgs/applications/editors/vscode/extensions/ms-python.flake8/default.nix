{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-python";
    name = "flake8";
    version = "2025.2.0";
    hash = "sha256-DbPm/ekturW31jqZw0fvVOvzxAY286eJmgDcahDt0K0=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/ms-python.flake8/changelog";
    description = "Python linting support for VS Code using Flake8";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.flake8";
    homepage = "https://github.com/microsoft/vscode-flake8";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
