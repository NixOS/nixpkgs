{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "elixir-syntax-vscode";
    publisher = "devkir";
    version = "0.1.2";
    hash = "sha256-VZuf0sfZVupF6KB5W52WowdHtiHMM9JVpsBWCPV97zw=";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/devkir.elixir-syntax-vscode/changelog";
    description = "Syntax highlighting support for the Elixir programming language.";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=devkir.elixir-syntax-vscode";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.frontear ];
  };
}
