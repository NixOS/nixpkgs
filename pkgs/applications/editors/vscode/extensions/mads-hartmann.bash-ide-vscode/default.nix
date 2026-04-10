{
  lib,
  vscode-utils,
  jq,
  moreutils,
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
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postInstall = ''
    cd "$out/$installPrefix"
    jq -e '
      .contributes.configuration.properties."bashIde.shellcheckPath".default = "${lib.getExe shellcheck}" |
      .contributes.configuration.properties."bashIde.shfmt.path".default = "${lib.getExe shfmt}"
    ' package.json | sponge package.json
  '';
  meta = {
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kamadorueda ];
  };
}
