{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "hardhat-solidity";
    publisher = "nomicfoundation";
    version = "0.9.1";
    hash = "sha256-PlqYeUe6qbyP/ec2EwxG8Uxg6wmJhayUzt4HpInpLAg=";
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
