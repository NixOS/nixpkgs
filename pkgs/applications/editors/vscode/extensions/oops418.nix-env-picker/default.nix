{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "nix-env-picker";
    publisher = "io-github-oops418";
    version = "0.0.4";
    hash = "sha256-LGw7Pd72oVgMqhKPX1dV2EgluX0/4rvKVb7Fx2H6hOI=";
  };
  meta = {
    description = "Visual Studio Code extension for seamless switching between Nix shells and flakes";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=io-github-oops418.nix-env-picker";
    homepage = "https://github.com/Oops418/nix-env-picker";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Oops418 ];
  };
}
