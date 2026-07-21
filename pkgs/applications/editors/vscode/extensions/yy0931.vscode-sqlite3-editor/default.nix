{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-sqlite3-editor";
    publisher = "yy0931";
    version = "1.0.214";
    hash = "sha256-lxH+j83R2ZYCWrEB0c70DRSCMn5iH1Xz/vXLZBE42Eg=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/yy0931.vscode-sqlite3-editor/changelog";
    description = "SQLite3 Editor for VSCode";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=yy0931.vscode-sqlite3-editor";
    homepage = "https://github.com/yy0931/sqlite3-editor";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.ch4og ];
  };
}
