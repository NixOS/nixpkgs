{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-sqlite3-editor";
    publisher = "yy0931";
    version = "1.0.212";
    hash = "sha256-mG75eEK7agZ8R4LNN5xM7GqaBQC5JKhUR0/ZogZTHpY=";
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
