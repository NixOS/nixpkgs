{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-thunder-client";
    publisher = "rangav";
    version = "2.41.0";
    hash = "sha256-c5oEaRMeTEWT0dtd6bzWMumhTEchOsLDXp+D76orL+k=";
  };

  meta = {
    description = "Lightweight Rest API Client for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=rangav.vscode-thunder-client";
    homepage = "https://github.com/thunderclient/thunder-client-support";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ AlexAntonik ];
  };
}
