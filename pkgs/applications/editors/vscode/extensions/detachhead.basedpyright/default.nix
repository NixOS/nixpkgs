{
  lib,
  vscode-utils,
  ...
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "basedpyright";
    publisher = "detachhead";
    version = "1.38.2";
    hash = "sha256-A53YEDmLi46rarYJ0K70dDDKpxZRkyy40+4i1VPlyWU=";
  };
  meta = {
    changelog = "https://github.com/detachhead/basedpyright/releases";
    description = "VS Code static type checking for Python (but based)";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=detachhead.basedpyright";
    homepage = "https://docs.basedpyright.com/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.hasnep ];
  };
}
