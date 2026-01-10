{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "checkpatch";
    publisher = "idanp";
    version = "0.0.9";
    hash = "sha256-l7YjQXl4SygawlZ0cXrY6A5tPrpbhZVZ8jUSItgfn80=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/idanp.checkpatch/changelog";
    description = "Using linux kernel checkpatch tool to lint code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=idanp.checkpatch";
    homepage = "https://github.com/idanpa/vscode-checkpatch";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
