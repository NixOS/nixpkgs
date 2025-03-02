{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "platformio-ide";
    publisher = "platformio";
    version = "3.3.4";
    hash = "sha256-qfNz4IYjCmCMFLtAkbGTW5xnsVT8iDnFWjrgkmr2Slk=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/platformio.platformio-ide/changelog";
    description = "Open source ecosystem for IoT development in VSCode";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=platformio.platformio-ide";
    homepage = "https://platformio.org/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}
