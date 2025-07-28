{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "lldb-dap";
    publisher = "llvm-vs-code-extensions";
    version = "0.2.15";
    hash = "sha256-Xr/TUpte9JqdvQ8eoD0l8ztg0tR8qwX/Ju1eVU6Xc0s=";
  };

  meta = {
    description = "Debugging with LLDB in Visual Studio Code";
    downloadPage = "hhttps://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.lldb-dap";
    homepage = "https://github.com/llvm/llvm-project";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.m0nsterrr ];
  };
}
