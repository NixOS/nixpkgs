{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "prettier-vscode";
    publisher = "esbenp";
<<<<<<< HEAD
    version = "11.0.2";
    hash = "sha256-PwP49p1gpxfx3AmGFhNvRBBc4SxWM2b9aaiUG/C+Uhg=";
=======
    version = "11.0.0";
    hash = "sha256-pNjkJhof19cuK0PsXJ/Q/Zb2H7eoIkfXJMLZJ4lDn7k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
