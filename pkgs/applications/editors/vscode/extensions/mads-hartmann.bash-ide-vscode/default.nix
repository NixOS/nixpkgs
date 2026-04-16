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
    version = "1.43.0";
    hash = "sha256-IpJCzoYZ+L39HqBts487E00RfVnZhLa9wUYs2FIV9pQ=";
  };
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postInstall = ''
    cd "$out/$installPrefix"
    jq -e '
      .contributes.configuration.properties."bashIde.shellcheckPath".default = "${shellcheck.exe}" |
      .contributes.configuration.properties."bashIde.shfmt.path".default = "${shfmt.exe}"
    ' package.json | sponge package.json
  '';
  meta = {
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kamadorueda ];
  };
}
