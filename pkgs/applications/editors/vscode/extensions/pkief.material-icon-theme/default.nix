{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "material-icon-theme";
    publisher = "PKief";
<<<<<<< HEAD
    version = "5.30.0";
    hash = "sha256-KddqajZBKz6RL4TcO12fLRdCWkd7NONPf2vs4vao3Ng=";
=======
    version = "5.29.0";
    hash = "sha256-cM2yZT/GMHtqPJFlEQZaDWl7YY456mLnw8hNUwgyQ0M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  meta = {
    description = "Material Design Icons for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items/?itemName=PKief.material-icon-theme";
    homepage = "https://github.com/material-extensions/vscode-material-icon-theme/blob/main/README.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.therobot2105 ];
  };
}
