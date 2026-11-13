{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-thunder-client";
    publisher = "rangav";
    version = "3.2.4";
    hash = "sha256-bFTnaGNo/DBFMI2wkc2DnBJBFfuVB2I2sn3Zx94TsR4=";
  };

  meta = {
    description = "Lightweight Rest API Client for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=rangav.vscode-thunder-client";
    homepage = "https://github.com/thunderclient/thunder-client-support";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ AlexAntonik ];
  };
}
