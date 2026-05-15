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
  executableConfig."direnv.path.executable".package = direnv;
  meta = {
    description = "direnv support for Visual Studio Code";
    license = lib.licenses.bsd0;
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=mkhl.direnv";
    maintainers = [ ];
  };
}
