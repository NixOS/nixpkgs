{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-eslint";
    publisher = "dbaeumer";
    version = "3.0.34";
    hash = "sha256-ynCPFzne4YS4WNjQSmGky+e2IaE3SLxj6FkjKyLPcAs=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/dbaeumer.vscode-eslint/changelog";
    description = "Integrates ESLint JavaScript into VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint";
    homepage = "https://github.com/Microsoft/vscode-eslint";
    license = lib.licenses.mit;
  };
}
