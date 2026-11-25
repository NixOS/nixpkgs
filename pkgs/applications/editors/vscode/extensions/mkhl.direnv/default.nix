{
  lib,
  vscode-utils,
  direnv,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "mkhl";
    name = "direnv";
    version = "0.17.0";
    hash = "sha256-9sFcfTMeLBGw2ET1snqQ6Uk//D/vcD9AVsZfnUNrWNg=";
  };
  defaultConfig."direnv.path.executable" = direnv;
  meta = {
    description = "direnv support for Visual Studio Code";
    license = lib.licenses.bsd0;
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=mkhl.direnv";
    maintainers = [ ];
  };
}
