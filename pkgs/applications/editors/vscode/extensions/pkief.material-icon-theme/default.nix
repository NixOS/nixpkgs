{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "material-icon-theme";
    publisher = "PKief";
    version = "5.33.1";
    hash = "sha256-GWHWEdi2kPkxS0RGAxFcy+njFCl1iiEBu41V/5sHqvc=";
  };
  meta = {
    description = "Material Design Icons for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items/?itemName=PKief.material-icon-theme";
    homepage = "https://github.com/material-extensions/vscode-material-icon-theme/blob/main/README.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}
