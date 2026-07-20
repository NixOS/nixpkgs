{
  stdenvNoCC,
  lib,
  vscode-utils,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef =
    let
      sources = {
        "x86_64-linux" = {
          arch = "linux-x64";
          hash = "sha256-fOqG/GSQmKDHA3J10x/m9q5URjSPAoWHqg/OfZtz418=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-MA2kXhM6rSp9OPtDm4daFrBpH+CNNXLjSG095QndOvM=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-UiA9Ar34UuHKBKm0B6jc+qWwzxlJbXEG2FaMBV39AeI=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-+v8U/aFNp/b6Dj62J+MLYQ8dcfO4qinWd/XST6ntnNc=";
        };
      };
    in
    {
      name = "vscode-python-envs";
      publisher = "ms-python";
      version = "1.36.0";
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  meta = {
    description = "Provides a unified python environment experience";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-python-envs";
    homepage = "https://github.com/microsoft/vscode-python-environments";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Zocker1999NET
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
