{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "prettier-vscode";
    publisher = "esbenp";
    version = "12.3.0";
    hash = "sha256-Zi5ihki/risHm75ERQxUgqhiTbpM6fknHLMCAkXrEVo=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/esbenp.prettier-vscode/changelog";
    description = "Code formatter using prettier";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode";
    homepage = "https://github.com/prettier/prettier-vscode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.datafoo ];
  };
}
