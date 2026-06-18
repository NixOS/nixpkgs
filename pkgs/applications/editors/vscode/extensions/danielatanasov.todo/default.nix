{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "todo";
    publisher = "danielatanasov";
    version = "0.2.0";
    hash = "sha256-5FNG4rNCD5OoTnnfE6ieHo26ArzonkqEK0Xaw4EJkg0=";
  };
  meta = {
    description = "Hightlight TODOs in comments";
    homepage = "https://github.com/Gismo359/todo-highlight#readme";
    changelog = "https://github.com/Gismo359/todo-highlight/blob/master/CHANGELOG.md";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=DanielAtanasov.todo";
    license = lib.licenses.mit;
  };
}
