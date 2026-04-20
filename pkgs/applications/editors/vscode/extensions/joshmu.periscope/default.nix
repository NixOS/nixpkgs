{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "periscope";
    publisher = "joshmu";
    version = "1.16.1";
    hash = "sha256-gYfsY5ZwB4vTDplWW49o9EZITY74CfM1FOrCxJ7+g6U=";
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
