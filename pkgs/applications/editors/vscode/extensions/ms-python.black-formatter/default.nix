{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ms-python";
    name = "black-formatter";
    version = "2026.4.0";
    hash = "sha256-lt/68RWEpoBFTBWEsSSb/KL6BRmdt8mELBA1ypb5Pm0=";
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
