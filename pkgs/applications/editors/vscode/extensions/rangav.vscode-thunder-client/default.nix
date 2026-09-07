{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-thunder-client";
    publisher = "rangav";
    version = "2.41.1";
    hash = "sha256-BLR5z5KttJt1wQOqDVyPRRNagoBihAeEdbBnHps7yhg=";
  };

  meta = {
    description = "Lightweight Rest API Client for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=rangav.vscode-thunder-client";
    homepage = "https://github.com/thunderclient/thunder-client-support";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ AlexAntonik ];
  };
}
