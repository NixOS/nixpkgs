{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-python";
    name = "isort";
    version = "2026.8.0";
    hash = "sha256-bYYQaUApD9DPI8RdLqgGXCe9f/RiKhCD2D/p95QFwdU=";
  };
  meta = {
    description = "Import sorting extension for Visual Studio Code using isort";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.isort";
    homepage = "https://github.com/microsoft/vscode-isort";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
