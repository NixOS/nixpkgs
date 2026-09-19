{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-python-envs";
    publisher = "ms-python";
    version = "1.36.0";
    hash = "sha256-oIVnHF554bz8ndSD8rRPFbWIS0EHqInXfIc6uGkd1KY=";
  };

  meta = {
    description = "Provides a unified python environment experience";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-python-envs";
    homepage = "https://github.com/microsoft/vscode-python-environments";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Zocker1999NET
    ];
  };
}
