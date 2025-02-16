{
  jq,
  lib,
  moreutils,
  shellcheck,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "shellcheck";
    publisher = "timonwong";
    version = "0.37.7";
    sha256 = "sha256-i8cVY8EcKSxnmWmRWDiARF79pOEcYMc+y+7i4d8EDTo=";
  };
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."shellcheck.executablePath".default = "${shellcheck}/bin/shellcheck"' package.json | sponge package.json
  '';
  meta = {
    description = "Integrates ShellCheck into VS Code, a linter for Shell scripts";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck";
    homepage = "https://github.com/vscode-shellcheck/vscode-shellcheck";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.raroh73 ];
  };
}
