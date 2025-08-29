{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "material-icon-theme";
    publisher = "PKief";
    version = "5.25.0";
    hash = "sha256-jkTFfyeFJ4ygsKJj41tWDJ91XitSs2onW4ni3rMNJE8=";
  };
  meta = {
    description = "Material Design Icons for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items/?itemName=PKief.material-icon-theme";
    homepage = "https://github.com/material-extensions/vscode-material-icon-theme/blob/main/README.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}
