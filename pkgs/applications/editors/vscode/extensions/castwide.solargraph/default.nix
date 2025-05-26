{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "solargraph";
    publisher = "castwide";
    version = "0.25.0";
    hash = "sha256-5SmCkHGCS8dYfdSm3NRk091jH44m+7kkj+VL84YKM4g=";
  };
  meta = {
    description = "Ruby language server featuring code completion, intellisense, and inline documentation";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=castwide.solargraph";
    homepage = "https://github.com/castwide/vscode-solargraph";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bbenno ];
  };
}
