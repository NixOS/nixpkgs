{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "material-icon-theme";
    publisher = "PKief";
    version = "5.29.0";
    hash = "sha256-cM2yZT/GMHtqPJFlEQZaDWl7YY456mLnw8hNUwgyQ0M=";
  };
  meta = {
    description = "Material Design Icons for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items/?itemName=PKief.material-icon-theme";
    homepage = "https://github.com/material-extensions/vscode-material-icon-theme/blob/main/README.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}
