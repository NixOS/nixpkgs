{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "r-syntax";
    publisher = "REditorSupport";
    version = "0.1.4";
    hash = "sha256-7MX01miPbiOfnxXaCMg0yAKHXsBcwRUYuiU9yTzMGIQ=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/REditorSupport.r-syntax/changelog";
    description = "R Synxtax Highlight for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=REditorSupport.r-syntax";
    homepage = "https://github.com/REditorSupport/vscode-R-syntax";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.ivyfanchiang
      lib.maintainers.pandapip1
    ];
  };
}
