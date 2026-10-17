{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "packaging";
    publisher = "claui";
    version = "0.2.5";
    hash = "sha256-WGs00Q1oa8Nz9dpKn3iZSjrhR0VKUwJWPGdm+wWtoxs=";
  };
  meta = {
    changelog = "https://github.com/claui/vscode-packaging/releases";
    description = "Visual Studio Code extension for PKGBUILDs in the Arch User Repository (AUR)";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=claui.packaging";
    homepage = "https://github.com/claui/vscode-packaging";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ilai-deutel ];
  };
}
