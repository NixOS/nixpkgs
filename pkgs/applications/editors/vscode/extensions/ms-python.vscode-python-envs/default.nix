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
          hash = "sha256-wIwNH57ABWXGHLzQWplrfdI075W/LXocscOJ0Pycev4=";
        };
        "aarch64-linux" = {
          arch = "linux-arm64";
          hash = "sha256-R4YLYHVeQOYvjaCJQajZ6+OPOqIWiCZjXmiAwfSJOFo=";
        };
        "x86_64-darwin" = {
          arch = "darwin-x64";
          hash = "sha256-t9XjC7oMd2Kpd8nXcdlnWB58A6NRU2hUA6g2c9IFaTw=";
        };
        "aarch64-darwin" = {
          arch = "darwin-arm64";
          hash = "sha256-PN4sV5qu+PhDB5TeDir51cmE3yYW1HdHRvE+950ty3k=";
        };
      };
    in
    {
      name = "vscode-python-envs";
      publisher = "ms-python";
      version = "1.33.2026051501";
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
