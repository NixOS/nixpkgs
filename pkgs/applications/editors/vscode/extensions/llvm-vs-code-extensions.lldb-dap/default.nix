{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "lldb-dap";
    publisher = "llvm-vs-code-extensions";
    version = "0.4.1";
    hash = "sha256-7eMVniepE4lDLAYsMpE5bKYvkfskGaOapxYUJy58mJA=";
  };

  meta = {
    description = "Debugging with LLDB in Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.lldb-dap";
    homepage = "https://github.com/llvm/llvm-project";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.m0nsterrr ];
  };
}
