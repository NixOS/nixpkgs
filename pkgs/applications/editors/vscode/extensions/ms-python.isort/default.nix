{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-python";
    name = "isort";
    version = "2025.0.0";
    hash = "sha256-nwt9Pv084jt9nWvxSXLIWu7981UGSbCgVRTrFfJA6q4=";
  };
  meta = with lib; {
    description = "Import sorting extension for Visual Studio Code using isort";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.isort";
    homepage = "https://github.com/microsoft/vscode-isort";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
