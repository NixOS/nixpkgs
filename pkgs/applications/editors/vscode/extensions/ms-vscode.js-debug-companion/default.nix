{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "js-debug-companion";
    publisher = "ms-vscode";
    version = "1.1.3";
    sha256 = "sha256-c4CokHh0UvFLLbeDXfqU3lOMrzWOvCY/nUbdaKxS3pM=";
  };

  meta = {
    description = "Companion extension to js-debug that provides capability for remote debugging";
    homepage = "https://github.com/microsoft/vscode-js-debug-companion";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.js-debug-companion";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
}
