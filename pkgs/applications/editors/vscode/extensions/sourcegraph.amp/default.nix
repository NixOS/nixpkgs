{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "sourcegraph";
    name = "amp";
    version = "0.0.1772799397";
    hash = "sha256-O3OnTWazDpdxSQuQo6VS0O8OsfK4WoPMs2w1LCV9Nyc=";
  };

  meta = {
    description = "Amp is a frontier coding agent for your editor and terminal, built by Sourcegraph.";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=sourcegraph.amp";
    homepage = "https://ampcode.com/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.katexochen ];
  };
}
