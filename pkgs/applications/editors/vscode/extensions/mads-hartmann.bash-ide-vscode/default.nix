{
  lib,
  vscode-utils,
  shfmt,
  shellcheck,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "mads-hartmann";
    name = "bash-ide-vscode";
    version = "1.43.0";
    hash = "sha256-IpJCzoYZ+L39HqBts487E00RfVnZhLa9wUYs2FIV9pQ=";
  };
  executableConfig = {
    "bashIde.shellcheckPath".package = shellcheck;
    "bashIde.shfmt.path".package = shfmt;
  };
  meta = {
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kamadorueda ];
  };
}
