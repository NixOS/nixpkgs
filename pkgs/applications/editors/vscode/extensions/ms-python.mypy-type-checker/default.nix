{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-python";
    name = "mypy-type-checker";
    version = "2026.4.0";
    hash = "sha256-N0zml16XSBwjGHzCR1L0W9WiSgqD/375VIQGpGfCkFE=";
  };

  meta = {
    changelog = "https://github.com/microsoft/vscode-mypy/releases";
    description = "VSCode extension for type checking support for Python files using Mypy";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.mypy-type-checker";
    homepage = "https://github.com/microsoft/vscode-mypy";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
