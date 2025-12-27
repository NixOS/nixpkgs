{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    publisher = "google";
    name = "colab";
    version = "0.1.4";
    hash = "sha256-15n8e7KHMHU16oScivd6aY8v5vnzlH+4ME9Z6qt3AHw=";
  };

  meta = {
    description = "A VS Code extension providing access to Google Colab. Colab is a hosted Jupyter Notebook service that requires no setup to use and provides free access to computing resources, including GPUs and TPUs.";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Google.colab";
    homepage = "https://github.com/googlecolab/colab-vscode";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.devoid ];
  };
}
