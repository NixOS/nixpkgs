{
  lib,
  vscode-utils,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "RooVeterinaryInc";
    name = "roo-cline";
    version = "3.28.3";
    hash = "sha256-aBS6T8S8+D9FGIAPi5dELKyqt3/oqFVa6XNDcTMYkoM=";
  };

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    description = "AI-powered autonomous coding agent that lives in your editor";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=RooVeterinaryInc.roo-cline";
    homepage = "https://github.com/RooVetGit/Roo-Code";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
