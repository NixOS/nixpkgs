{
  lib,
  vscode-utils,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "RooVeterinaryInc";
    name = "roo-cline";
    version = "3.18.3";
    hash = "sha256-kg4kXO7UwDQPXb6CAysaez2v8FPRMbX+f41vE68V0QA=";
  };

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    description = "AI-powered autonomous coding agent that lives in your editor";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=RooVeterinaryInc.roo-cline";
    homepage = "https://github.com/RooVetGit/Roo-Code";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
