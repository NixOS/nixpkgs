{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-python";
    name = "mypy-type-checker";
    version = "2026.6.0";
    hash = "sha256-Sis9Tm5uWTyAIJnHvdh/dwOs580YprqDQ3XP8FhWvw0=";
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
