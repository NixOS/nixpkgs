{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "hardhat-solidity";
    publisher = "nomicfoundation";
    version = "0.8.29";
    hash = "sha256-0WC4MBCjY2TyZmeBtiCsKD95dudtCfo2HzvMWorWbOY=";
  };

  meta = {
    changelog = "https://github.com/NomicFoundation/hardhat-vscode/blob/main/client/CHANGELOG.md";
    description = "Solidity and Hardhat support for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=nomicfoundation.hardhat-solidity";
    homepage = "https://github.com/NomicFoundation/hardhat-vscode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.iamanaws ];
  };
}
