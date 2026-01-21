{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "prettier-vscode";
    publisher = "esbenp";
    version = "11.0.2";
    hash = "sha256-PwP49p1gpxfx3AmGFhNvRBBc4SxWM2b9aaiUG/C+Uhg=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/esbenp.prettier-vscode/changelog";
    description = "Code formatter using prettier";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode";
    homepage = "https://github.com/prettier/prettier-vscode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.datafoo ];
  };
}
