{
  lib,
  shfmt,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "shell-format";
    publisher = "foxundermoon";
    version = "7.2.5";
    hash = "sha256-kfpRByJDcGY3W9+ELBzDOUMl06D/vyPlN//wPgQhByk=";
  };

  executableConfig."shellformat.path".package = shfmt;

  meta = {
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format";
    homepage = "https://github.com/foxundermoon/vs-shell-format";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dbirks ];
  };
}
