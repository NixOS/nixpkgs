{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-eslint";
    publisher = "dbaeumer";
<<<<<<< HEAD
    version = "3.0.20";
    hash = "sha256-X/HqQM1CDUvIi8p8i++6/aZl2hQWbeKIwgmDx/cb5UQ=";
=======
    version = "3.0.16";
    hash = "sha256-UxD07bouMK8nuysh5TAV7ZVhkLiOV6R1qfvVZcXB2Hc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/dbaeumer.vscode-eslint/changelog";
    description = "Integrates ESLint JavaScript into VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint";
    homepage = "https://github.com/Microsoft/vscode-eslint";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.datafoo ];
  };
}
