{ lib, vscode-utils }:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "lldb-dap";
    publisher = "llvm-vs-code-extensions";
<<<<<<< HEAD
    version = "0.4.1";
    hash = "sha256-7eMVniepE4lDLAYsMpE5bKYvkfskGaOapxYUJy58mJA=";
=======
    version = "0.2.18";
    hash = "sha256-H2CSy+Zow6inLUgSW5VNHZBEmag1acslX3bkw3XYcKA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Debugging with LLDB in Visual Studio Code";
<<<<<<< HEAD
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.lldb-dap";
=======
    downloadPage = "hhttps://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.lldb-dap";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/llvm/llvm-project";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.m0nsterrr ];
  };
}
