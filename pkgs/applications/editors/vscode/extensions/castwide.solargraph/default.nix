{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "solargraph";
    publisher = "castwide";
    version = "0.24.1";
    hash = "sha256-M96kGuCKo232rIwLovDU+C/rhEgZWT4s/zsR7CUYPnk=";
  };
  meta = {
    description = "Ruby language server featuring code completion, intellisense, and inline documentation";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=castwide.solargraph";
    homepage = "https://github.com/castwide/vscode-solargraph";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bbenno ];
  };
}
