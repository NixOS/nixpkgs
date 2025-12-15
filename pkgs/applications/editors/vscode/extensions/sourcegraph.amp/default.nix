{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "sourcegraph";
    name = "amp";
    version = "0.0.1765541481";
    hash = "sha256-LE4IsnLa5fI5hdhrrMzqhdomvDa6gMpTPtQ+xkGSyWo=";
  };

  meta = {
    description = "Amp is a frontier coding agent for your editor and terminal, built by Sourcegraph.";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=sourcegraph.amp";
    homepage = "https://ampcode.com/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.katexochen ];
  };
}
