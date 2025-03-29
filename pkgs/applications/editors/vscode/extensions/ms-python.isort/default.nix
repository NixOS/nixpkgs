{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-python";
    name = "isort";
    version = "2023.13.13171013";
    hash = "sha256-UBV9i3LPVv60+toy+kJvESAuJHRmH/uEIwjTidYUXLc=";
  };
  meta = with lib; {
    description = "Import sorting extension for Visual Studio Code using isort";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.isort";
    homepage = "https://github.com/microsoft/vscode-isort";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
