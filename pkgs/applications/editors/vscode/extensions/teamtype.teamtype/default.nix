{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "teamtype";
    name = "teamtype";
    version = "0.8.0";
    hash = "sha256-p9bynTMmCn6pu7SVEABeSawv9VjWpE8KecQOeIsE/LE=";
  };

  meta = {
    description = "Extension for real-time co-editing of local text files";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=teamtype.teamtype";
    homepage = "https://github.com/teamtype/teamtype/tree/main/vscode-plugin";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.ethancedwards8 ];
    teams = [ lib.teams.ngi ];
  };
}
