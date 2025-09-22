{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "js-debug";
    publisher = "ms-vscode";
    version = "1.104.0";
    sha256 = "sha256-hW25NClL2LeHad2RyGkEx+NeNWuwWyI6nk2Os4yxeuM=";
  };

  meta = {
    description = "An extension for debugging Node.js programs and Chrome";
    homepage = "https://github.com/microsoft/vscode-js-debug";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.js-debug";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
}
