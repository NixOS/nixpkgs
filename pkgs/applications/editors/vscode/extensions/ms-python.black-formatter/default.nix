{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-python";
    name = "black-formatter";
    version = "2024.6.0";
    hash = "sha256-Waw+WhazNqVoihC/K/tPFH4tCeYYVOFDBfg+AWvs3q4=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/ms-python.black-formatter/changelog";
    description = "Formatter extension for Visual Studio Code using black";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter";
    homepage = "https://github.com/microsoft/vscode-black-formatter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      amadejkastelic
      sikmir
    ];
  };
}
