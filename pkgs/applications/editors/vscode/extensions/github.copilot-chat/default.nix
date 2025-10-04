{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "github";
    name = "copilot-chat";
    version = "0.31.3";
    hash = "sha256-Kvg5gmvAcz+K6mWBzWoNnkqEWAPRgC+w0idUC6RzM0g=";
  };

  meta = {
    description = "GitHub Copilot Chat is a companion extension to GitHub Copilot that houses experimental chat features";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat";
    homepage = "https://github.com/features/copilot";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.laurent-f1z1 ];
  };
}
