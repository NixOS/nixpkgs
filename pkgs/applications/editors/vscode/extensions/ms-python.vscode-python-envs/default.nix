{
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-python-envs";
    publisher = "ms-python";
    version = "1.33.2026051501";
    hash = "sha256-V5anlwzLt0V08HsO6TCBIUPD3VPhyohg7YnSc/1++GE=";
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
