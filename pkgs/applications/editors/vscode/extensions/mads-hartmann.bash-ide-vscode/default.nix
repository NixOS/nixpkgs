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
    version = "1.43.2";
    hash = "sha256-dNSkfsp3o3ErFQrQjtoU9B8d9fz3tcyB5gSwt3S36F0=";
  };
  defaultConfig = {
    "bashIde.shellcheckPath" = shellcheck;
    "bashIde.shfmt.path" = shfmt;
  };
  meta = {
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kamadorueda ];
  };
}
