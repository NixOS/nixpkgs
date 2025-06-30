{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "github";
    name = "copilot-chat";
    version = "0.28.2";
    hash = "sha256-o6h9AOeBMRqVkhSgHUE2/vmsmJCXciY21mIQD7SUHOU=";
  };

  meta = {
    description = "GitHub Copilot Chat is a companion extension to GitHub Copilot that houses experimental chat features";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat";
    homepage = "https://github.com/features/copilot";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.laurent-f1z1 ];
  };
}
