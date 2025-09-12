{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "lldb-dap";
    publisher = "llvm-vs-code-extensions";
    version = "0.2.16";
    hash = "sha256-q0wBPSQHy/R8z5zb3iMdapzrn7c9y9X6Ow9CXY3lwtc=";
  };

  meta = {
    description = "Debugging with LLDB in Visual Studio Code";
    downloadPage = "hhttps://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.lldb-dap";
    homepage = "https://github.com/llvm/llvm-project";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.m0nsterrr ];
  };
}
