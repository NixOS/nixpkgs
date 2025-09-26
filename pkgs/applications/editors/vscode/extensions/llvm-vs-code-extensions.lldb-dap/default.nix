{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "lldb-dap";
    publisher = "llvm-vs-code-extensions";
    version = "0.2.18";
    hash = "sha256-H2CSy+Zow6inLUgSW5VNHZBEmag1acslX3bkw3XYcKA=";
  };

  meta = {
    description = "Debugging with LLDB in Visual Studio Code";
    downloadPage = "hhttps://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.lldb-dap";
    homepage = "https://github.com/llvm/llvm-project";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.m0nsterrr ];
  };
}
