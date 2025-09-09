{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "periscope";
    publisher = "joshmu";
    version = "1.15.1";
    hash = "sha256-Ssa3qoookSa/JnmZl1AmlT48exAgd6pbwdzzsmTcEqs=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/joshmu.periscope/changelog";
    description = "Visual Studio Code extension for fuzzy search and navigation";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=joshmu.periscope";
    homepage = "https://github.com/joshmu/periscope";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.smissingham ];
  };
}
