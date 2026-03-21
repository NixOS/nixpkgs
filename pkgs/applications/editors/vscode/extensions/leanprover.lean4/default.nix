{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "lean4";
    publisher = "leanprover";
    version = "0.0.225";
    hash = "sha256-JVsOHO2r7YHC4QxvpjoIgT5rZhW2SS24xu3TMnoRQi8=";
  };

  meta = {
    description = "This extension provides VS Code support for the Lean 4 theorem prover and programming language";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=leanprover.lean4";
    homepage = "https://github.com/leanprover/vscode-lean4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ alexstaeding ];
  };
}
