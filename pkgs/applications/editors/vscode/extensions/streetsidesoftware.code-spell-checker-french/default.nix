{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "code-spell-checker-french";
    publisher = "streetsidesoftware";
    version = "1.0.0";
    hash = "sha256-6/OJSRyOzcS9vubY59JWmfX2iC9frS51NC4ivvsvfik=";
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
