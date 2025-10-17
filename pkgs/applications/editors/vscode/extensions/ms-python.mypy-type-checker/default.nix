{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-python";
    name = "mypy-type-checker";
    version = "2025.2.0";
    hash = "sha256-VJ/XSC4cbIjgxKLsXxUxwko+HR0U59c8OrhYnKPJu4g=";
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
