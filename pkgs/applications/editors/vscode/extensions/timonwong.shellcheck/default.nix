{
  lib,
  shellcheck,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "shellcheck";
    publisher = "timonwong";
    version = "0.39.3";
    sha256 = "sha256-A87dG+bBNCMZ8ERDGpVJIP7lXL8rfRely2Uo/ZMsgVI=";
  };
  executableConfig."shellcheck.executablePath".package = shellcheck;
  meta = {
    description = "Integrates ShellCheck into VS Code, a linter for Shell scripts";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck";
    homepage = "https://github.com/vscode-shellcheck/vscode-shellcheck";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
