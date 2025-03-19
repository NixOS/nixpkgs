{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "RooVeterinaryInc";
    name = "roo-cline";
    version = "3.8.6";
    hash = "sha256-t3QUqe0qYizrJQcsEmYYmNYS/cpYiHQXJHtzHk9MGS8=";
  };

  meta = {
    description = "AI-powered autonomous coding agent that lives in your editor";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=RooVeterinaryInc.roo-cline";
    homepage = "https://github.com/RooVetGit/Roo-Code";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
