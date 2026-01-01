{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "ndonfris";
    name = "fish-lsp";
<<<<<<< HEAD
    version = "0.1.18";
    hash = "sha256-skNFNiVx7g/lpsxegTync9yEjt+h/Eb+5TnByeLXSPY=";
=======
    version = "0.1.16";
    hash = "sha256-6WsBJbQ9CgiZ7Wn9U33MxEEorR96zKtGXsMRJZ3j2Dk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "LSP implementation for the fish shell language";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ndonfris.fish-lsp";
    homepage = "https://github.com/ndonfris/fish-lsp";
    license = lib.licenses.mit;
  };
}
