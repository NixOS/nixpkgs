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
          hash = "sha256-dd7mnTkw5YkoyOLX1E5MjTLSAla9WwLH6Hwn7lZQ7Cw=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-DGBz6/AiC4Paq0mZmn8SU5w8/sKk53/vjD4drVJei80=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-QHXXnboecXavbJ6savSfoVMKHU+GQSQSAuphjhYmgKA=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-yLHz7tto6xKG6Wj1PszKBac/Y3GoUjaCCAKMWa03STk=";
        };
      };
    in
    {
      name = "vscode-python-envs";
      publisher = "ms-python";
      version = "1.33.2026052901";
    }
    // sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");

  meta = {
    description = "Provides a unified python environment experience";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-python-envs";
    homepage = "https://github.com/microsoft/vscode-python-environments";
    changelog = "https://marketplace.visualstudio.com/items/ms-python.vscode-python-envs/changelog";
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
