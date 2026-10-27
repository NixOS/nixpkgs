{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-thunder-client";
    publisher = "rangav";
    version = "2.41.7";
    hash = "sha256-UBkETeaIBhAI3kMNpzsXCZ/Vqlxg8XziMyg4yWM4EGk=";
  };

  meta = {
    description = "Lightweight Rest API Client for VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=rangav.vscode-thunder-client";
    homepage = "https://github.com/thunderclient/thunder-client-support";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ AlexAntonik ];
  };
}
