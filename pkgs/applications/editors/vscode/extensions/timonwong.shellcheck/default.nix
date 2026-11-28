{
  lib,
  shellcheck,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "shellcheck";
    publisher = "timonwong";
    version = "0.40.1";
    sha256 = "sha256-OFe7XZCoac31V1ZK75tpXmuCmyTdGzPxDo7fJkcUiV4=";
  };
  defaultConfig."shellcheck.executablePath" = shellcheck;
  meta = {
    description = "Integrates ShellCheck into VS Code, a linter for Shell scripts";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck";
    homepage = "https://github.com/vscode-shellcheck/vscode-shellcheck";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
