{
  lib,
  vscode-utils,
  ...
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "basedpyright";
    publisher = "detachhead";
    version = "1.36.2";
    hash = "sha256-FOu5ZpjNhtWxV+7Jt9V1RZ4YrK5BZ5t8Ut06raZURFI=";
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
