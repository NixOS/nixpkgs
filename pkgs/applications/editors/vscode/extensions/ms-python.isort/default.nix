{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-python";
    name = "isort";
    version = "2026.4.0";
    hash = "sha256-9UwAZfr8MnshHvZFCXl2v8IpgFJJrYuM5Z6Zn/uqlOQ=";
  };
  meta = {
    description = "Import sorting extension for Visual Studio Code using isort";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.isort";
    homepage = "https://github.com/microsoft/vscode-isort";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
