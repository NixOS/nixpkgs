{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "simple-perl";
    publisher = "zhiyuan-lin";
    version = "0.0.4";
    hash = "sha256-rXpAWnB6NNLfYqkxPe9TF3uog7+thnt7O7vphH4dtmA=";
  };
  meta = {
    description = "Supports perltidy and perlcritic.";
    homepage = "https://github.com/itsuki-hayashi/vscode-perl#readme";
    changelog = "https://github.com/itsuki-hayashi/vscode-perl/blob/master/CHANGELOG.md";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=zhiyuan-lin.simple-perl";
    license = lib.licenses.mit;
  };
}
