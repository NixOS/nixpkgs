{
  lib,
  vscode-utils,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "RooVeterinaryInc";
    name = "roo-cline";
    version = "3.35.1";
    hash = "sha256-8KnUpKcBN1C7FyHBRDwvgi4TZGUltm4LS9XwF/9WaYc=";
  };

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    description = "AI-powered autonomous coding agent that lives in your editor";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=RooVeterinaryInc.roo-cline";
    homepage = "https://github.com/RooVetGit/Roo-Code";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
