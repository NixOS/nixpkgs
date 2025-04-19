{
  lib,
  vscode-utils,
  vscode-extensions-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "RooVeterinaryInc";
    name = "roo-cline";
    version = "3.13.0";
    hash = "sha256-vVl8hMMpCrLP+/U6KJ3Qz/q0OYgQuEMfu8UzpScER8o=";
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
