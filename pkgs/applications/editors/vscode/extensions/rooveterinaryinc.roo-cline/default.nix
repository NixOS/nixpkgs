{
  lib,
  vscode-utils,
  vscode-extensions-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "RooVeterinaryInc";
    name = "roo-cline";
    version = "3.11.9";
    hash = "sha256-+Bi9nHRXXZGKGvTS8o0CbtS6KBJmQz+Wiiinqs16vZA=";
  };

  passthru.updateScript = vscode-extensions-update-script { };

  meta = {
    description = "AI-powered autonomous coding agent that lives in your editor";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=RooVeterinaryInc.roo-cline";
    homepage = "https://github.com/RooVetGit/Roo-Code";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
