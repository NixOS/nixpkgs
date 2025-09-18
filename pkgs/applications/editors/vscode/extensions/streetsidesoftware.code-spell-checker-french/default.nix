{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "code-spell-checker-french";
    publisher = "streetsidesoftware";
    version = "0.4.4";
    hash = "sha256-9BVSQFysgKPKp1e6noSv2szVSQvYH7nOuphJeiso55s=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/streetsidesoftware.code-spell-checker-french/changelog";
    description = "French dictionary extension for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker-french";
    homepage = "https://github.com/streetsidesoftware/vscode-cspell-dict-extensions#readme";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aduh95 ];
  };
}
