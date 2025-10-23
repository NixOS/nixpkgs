{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-sqlite3-editor";
    publisher = "yy0931";
    version = "1.0.208";
    hash = "sha256-4NOyMHp42RS7qsx0Zy86kqQzKgQkh3WprRoEI6GIXvg=";
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
