{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "sourcegraph";
    name = "amp";
    version = "0.0.1767211791";
    hash = "sha256-r8CjaSOXgnFkzcnyospFI3IwVpvc18KmYzwBpuv1Ab0=";
  };

  meta = {
    description = "Amp is a frontier coding agent for your editor and terminal, built by Sourcegraph.";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=sourcegraph.amp";
    homepage = "https://ampcode.com/";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.katexochen ];
  };
}
