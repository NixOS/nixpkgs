{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "mypy-type-checker";
    publisher = "ms-python";
    version = "2025.1.10381011";
    hash = "sha256-boKUxLOAgQJP13zX/NMhg1MtcrPVQJt5gLbxI7gVSu4=";
  };

  meta = {
    changelog = "https://github.com/microsoft/vscode-mypy/releases";
    description = "VSCode extension for type checking support for Python files using Mypy";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.mypy-type-checker";
    homepage = "https://github.com/microsoft/vscode-mypy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
